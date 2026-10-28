/*
 * Change Graylog's password_secret by re-encrypting everything that depends on it.
 * Run with mongosh against the graylog database while every Graylog node is stopped.
 *
 *   OLD_SECRET / NEW_SECRET  the current and the new password_secret (environment)
 *   MODE=check (default)     decrypt everything with OLD_SECRET and report; writes nothing
 *   MODE=apply               re-encrypt with NEW_SECRET, then verify with NEW_SECRET
 *   DB=graylog (default)     database to work on
 *
 * What depends on password_secret (Graylog 7.1 source):
 *   - EncryptedValue fields ({encrypted_value, salt}) in any collection: AES-CBC/PKCS5, key = secret
 *     (trimmed) cut/padded to 16/24/32 bytes, IV = salt; legacy values use ISO10126 padding.
 *     One of them (cluster_config PreflightEncryptedSecret) holds the secret itself and is checked
 *     at startup; it is rewritten with NEW_SECRET as plain text.
 *   - access_tokens.token (token_type 1): AES-SIV (RFC 5297), key = SHA-256(secret),
 *     CTR key = bytes 0-15, MAC key = bytes 16-31. Re-encrypted, so existing tokens keep working.
 *   - users with legacy SHA-1 password hashes (salted with the secret): reported only, their
 *     passwords must be reset.
 *   - JWT/session signing: nothing stored; sessions end and users log in again.
 * Values are never printed; "fingerprint" is a SHA-256 over all decrypted values except the
 * startup check value, so a check with OLD_SECRET before and NEW_SECRET after must print the same.
 */
const crypto = require('crypto');
const env = process.env;
const MODE = (env.MODE || 'check').toLowerCase();
const OLD = env.OLD_SECRET || '';
const NEW = env.NEW_SECRET || '';
if (!['check', 'apply'].includes(MODE)) throw new Error('MODE must be check or apply');
if (OLD.trim().length < 16) throw new Error('OLD_SECRET missing or shorter than 16 characters');
if (MODE === 'apply' && (NEW.trim().length < 16 || NEW === OLD)) throw new Error('NEW_SECRET missing, shorter than 16 characters or equal to OLD_SECRET');

// ---------------------------------------------------------------- AES-CBC (EncryptedValue)
function cbcKey(secret) {
  const b = Buffer.from(secret.trim(), 'utf8');
  const len = [16, 24, 32].includes(b.length) ? b.length : b.length < 16 ? 16 : b.length > 32 ? 32 : (Math.floor(b.length / 8) + 1) * 8;
  const k = Buffer.alloc(len); b.copy(k, 0, 0, Math.min(b.length, len)); return k;
}
function cbcDecrypt(hex, secret, salt) {
  const key = cbcKey(secret), iv = Buffer.from(salt, 'utf8');
  try {
    const d = crypto.createDecipheriv('aes-' + key.length * 8 + '-cbc', key, iv);
    return Buffer.concat([d.update(Buffer.from(hex, 'hex')), d.final()]).toString('utf8');
  } catch (e) { // legacy: no padding check, ISO10126 (last byte = pad count)
    const d = crypto.createDecipheriv('aes-' + key.length * 8 + '-cbc', key, iv); d.setAutoPadding(false);
    const p = Buffer.concat([d.update(Buffer.from(hex, 'hex')), d.final()]);
    const n = p[p.length - 1]; if (n < 1 || n > 16) throw new Error('bad padding');
    return p.subarray(0, p.length - n).toString('utf8');
  }
}
function cbcEncrypt(text, secret) {
  const key = cbcKey(secret), salt = crypto.randomBytes(8).toString('hex');
  const c = crypto.createCipheriv('aes-' + key.length * 8 + '-cbc', key, Buffer.from(salt, 'utf8'));
  return { value: Buffer.concat([c.update(text, 'utf8'), c.final()]).toString('hex'), salt };
}

// ---------------------------------------------------------------- AES-SIV (access tokens)
function aesBlock(key, block) { const c = crypto.createCipheriv('aes-' + key.length * 8 + '-ecb', key, null); c.setAutoPadding(false); return Buffer.concat([c.update(block), c.final()]); }
function dbl(b) { const o = Buffer.alloc(16); let carry = 0; for (let i = 15; i >= 0; i--) { o[i] = ((b[i] << 1) | carry) & 0xff; carry = b[i] >> 7; } if (b[0] & 0x80) o[15] ^= 0x87; return o; }
function xor(a, b) { const o = Buffer.alloc(a.length); for (let i = 0; i < a.length; i++) o[i] = a[i] ^ b[i]; return o; }
function cmac(key, msg) {
  const k1 = dbl(aesBlock(key, Buffer.alloc(16))), k2 = dbl(k1);
  const n = Math.max(1, Math.ceil(msg.length / 16)), full = msg.length > 0 && msg.length % 16 === 0;
  let last = Buffer.alloc(16); msg.copy(last, 0, (n - 1) * 16);
  if (full) last = xor(last, k1); else { last[msg.length - (n - 1) * 16] = 0x80; last = xor(last, k2); }
  let x = Buffer.alloc(16);
  for (let i = 0; i < n - 1; i++) x = aesBlock(key, xor(x, msg.subarray(i * 16, i * 16 + 16)));
  return aesBlock(key, xor(x, last));
}
function s2v(macKey, ad, p) {
  let d = cmac(macKey, Buffer.alloc(16));
  for (const a of ad) d = xor(dbl(d), cmac(macKey, a));
  let t;
  if (p.length >= 16) { t = Buffer.from(p); const off = p.length - 16; for (let i = 0; i < 16; i++) t[off + i] ^= d[i]; }
  else { const pad = Buffer.alloc(16); p.copy(pad); pad[p.length] = 0x80; t = xor(dbl(d), pad); }
  return cmac(macKey, t);
}
function ctr(ctrKey, v, data) { const q = Buffer.from(v); q[8] &= 0x7f; q[12] &= 0x7f; const c = crypto.createCipheriv('aes-' + ctrKey.length * 8 + '-ctr', ctrKey, q); return Buffer.concat([c.update(data), c.final()]); }
function sivEncrypt(macKey, ctrKey, plain, ad = []) { const v = s2v(macKey, ad, plain); return Buffer.concat([v, ctr(ctrKey, v, plain)]); }
function sivDecrypt(macKey, ctrKey, data, ad = []) {
  const v = data.subarray(0, 16), p = ctr(ctrKey, v, data.subarray(16));
  if (!crypto.timingSafeEqual(s2v(macKey, ad, p), v)) throw new Error('SIV authentication failed');
  return p;
}
function tokenKeys(secret) { const k = crypto.createHash('sha256').update(secret, 'utf8').digest(); return { ctrKey: k.subarray(0, 16), macKey: k.subarray(16, 32) }; }
const tokenDecrypt = (hex, secret) => { const k = tokenKeys(secret); return sivDecrypt(k.macKey, k.ctrKey, Buffer.from(hex, 'hex')).toString('utf8'); };
const tokenEncrypt = (text, secret) => { const k = tokenKeys(secret); return sivEncrypt(k.macKey, k.ctrKey, Buffer.from(text, 'utf8')).toString('hex'); };

// RFC 5297 A.1 test vector: refuse to run if the SIV code is wrong.
(function selfTest() {
  const key = Buffer.from('fffefdfcfbfaf9f8f7f6f5f4f3f2f1f0f0f1f2f3f4f5f6f7f8f9fafbfcfdfeff', 'hex');
  const out = sivEncrypt(key.subarray(0, 16), key.subarray(16), Buffer.from('112233445566778899aabbccddee', 'hex'), [Buffer.from('101112131415161718191a1b1c1d1e1f2021222324252627', 'hex')]);
  if (out.toString('hex') !== '85632d07c6e8f37f950acd320a2ecc9340c02b9690c4dc04daef7f6afe5c') throw new Error('AES-SIV self-test failed');
})();

// ---------------------------------------------------------------- walk the database
const g = db.getSiblingDB(env.DB || 'graylog');
const fp = [];
const PREFLIGHT = 'cluster_config :: payload.encrypted_secret';
const stats = { values: 0, valuesOk: 0, valuesEmpty: 0, failed: [], tokens: 0, tokensOk: 0, preflight: 'missing' };

function visit(o, path, fn) {
  if (o === null || typeof o !== 'object') return false;
  if (Array.isArray(o)) { let ch = false; o.forEach((x, i) => { ch = visit(x, path + '[]', fn) || ch; }); return ch; }
  if (typeof o.encrypted_value === 'string' && typeof o.salt === 'string') return fn(o, path);
  let ch = false; for (const k of Object.keys(o)) ch = visit(o[k], path ? path + '.' + k : k, fn) || ch; return ch;
}

const collections = g.getCollectionNames().filter(c => !c.startsWith('system.')).sort();
for (const c of collections) {
  g.getCollection(c).find().forEach(doc => {
    const changed = visit(doc, '', (ev, path) => {
      const where = c + ' :: ' + path;
      if (!ev.encrypted_value) { stats.valuesEmpty++; return false; }
      stats.values++;
      let plain;
      try { plain = cbcDecrypt(ev.encrypted_value, OLD, ev.salt); } catch (e) { stats.failed.push(where + ' (' + doc._id + ')'); return false; }
      if (where === PREFLIGHT) { stats.preflight = plain === OLD.trim() || plain === OLD ? 'matches OLD_SECRET' : 'DOES NOT match OLD_SECRET'; plain = NEW; }
      stats.valuesOk++;
      if (where !== PREFLIGHT) fp.push(where + '\u0000' + doc._id + '\u0000' + plain);
      if (MODE !== 'apply') return false;
      const n = cbcEncrypt(plain, NEW); ev.encrypted_value = n.value; ev.salt = n.salt; return true;
    });
    if (changed) g.getCollection(c).replaceOne({ _id: doc._id }, doc);
  });
}
g.access_tokens.find({ token: { $type: 'string' } }).forEach(t => {
  stats.tokens++;
  let plain;
  try { plain = tokenDecrypt(t.token, OLD); } catch (e) { stats.failed.push('access_tokens (' + t._id + ', token_type ' + t.token_type + ')'); return; }
  stats.tokensOk++;
  fp.push('access_tokens\u0000' + t._id + '\u0000' + plain);
  if (MODE === 'apply') g.access_tokens.updateOne({ _id: t._id }, { $set: { token: tokenEncrypt(plain, NEW), token_type: 1 } });
});
const sha1Users = g.users.find({ password: { $regex: '^[a-f0-9]{40}$' } }, { username: 1 }).toArray().map(u => u.username);

print('mode: ' + MODE + ', database: ' + g.getName());
print('encrypted values: ' + stats.valuesOk + '/' + stats.values + ' decrypted with OLD_SECRET (' + stats.valuesEmpty + ' empty)');
print('startup check value: ' + stats.preflight);
print('access tokens: ' + stats.tokensOk + '/' + stats.tokens + ' decrypted with OLD_SECRET');
print('users with legacy SHA-1 passwords (reset needed): ' + (sha1Users.length ? sha1Users.join(', ') : 'none'));
print('fingerprint: ' + crypto.createHash('sha256').update(fp.sort().join('\u0001')).digest('hex').slice(0, 16));
if (stats.failed.length) { print('FAILED to decrypt:'); stats.failed.forEach(f => print('  ' + f)); }

if (MODE === 'apply') { // verify everything with the new secret
  let bad = 0, n = 0;
  for (const c of collections) {
    for (const doc of g.getCollection(c).find().toArray()) {
      visit(doc, '', (ev, path) => {
        if (!ev.encrypted_value) return false;
        n++;
        try { const p = cbcDecrypt(ev.encrypted_value, NEW, ev.salt); if (c + ' :: ' + path === PREFLIGHT && p !== NEW) bad++; } catch (e) { bad++; }
        return false;
      });
    }
  }
  for (const t of g.access_tokens.find({ token: { $type: 'string' } }).toArray()) {
    n++;
    try { tokenDecrypt(t.token, NEW); } catch (e) { bad++; }
  }
  print('verify with NEW_SECRET: ' + (n - bad) + '/' + n + ' ok');
  if (bad) throw new Error('verification failed');
}
if (stats.failed.length || stats.preflight.startsWith('DOES NOT')) throw new Error('not everything decrypts with OLD_SECRET');
