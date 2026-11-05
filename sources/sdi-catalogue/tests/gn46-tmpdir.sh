#!/usr/bin/env bash
# Checks the gn46.tmpdir guard: the init container deletes old files in that directory,
# so the chart must only accept a subdirectory of /var/local/gis_sdi/tmp/.
# Needs only helm. Run from anywhere: sources/sdi-catalogue/tests/gn46-tmpdir.sh
set -u
cd "$(dirname "$0")/.." || exit 2

failures=0
total=0

render() {
  helm template t . --set gn5.enabled=true --set-string "gn46.tmpdir=$1" 2>&1
}

fail() {
  echo "FAIL: $1"
  failures=$((failures + 1))
}

expect_rejected() {
  total=$((total + 1))
  local out
  out=$(render "$1")
  # Rejected by values.schema.json or by the guard in the template
  if ! grep -q '^Error' <<<"$out"; then
    fail "'$1' should be rejected"
  elif grep -q 'init-tmpdir' <<<"$out"; then
    fail "'$1' was rejected but an init container was still rendered"
  fi
}

expect_accepted() {
  total=$((total + 1))
  local dir=$1 out
  out=$(render "$dir")
  grep -q 'gn46.tmpdir must be a subdirectory' <<<"$out" && { fail "'$dir' should be accepted"; return; }
  grep -qF "\"mkdir -p $dir && (find $dir -mindepth 1 -mtime +1 -delete || true)\"" <<<"$out" \
    || fail "'$dir' did not render the expected init container command"
  grep -qF "value: \"-Djava.io.tmpdir=$dir\"" <<<"$out" \
    || fail "'$dir' did not render JAVA_TOOL_OPTIONS"
}

expect_disabled() {
  total=$((total + 1))
  local out
  out=$(render "")
  grep -q 'init-tmpdir' <<<"$out" && fail "empty tmpdir should not render the init container"
  grep -q 'JAVA_TOOL_OPTIONS' <<<"$out" && fail "empty tmpdir should not render JAVA_TOOL_OPTIONS"
  grep -q '^Error' <<<"$out" && fail "empty tmpdir should render without errors"
}

expect_disabled

# Types and ranges are checked by values.schema.json
for bad in gn46.max_upload_size=50GiB gn46.max_upload_size=0 gn46.max_upload_size=1.5 \
  gn46.opendal.presignExpirySeconds=-1 gn46.opendal.presignExpirySeconds=abc; do
  total=$((total + 1))
  helm template t . --set gn5.enabled=true --set-string "$bad" 2>&1 | grep -q '^Error' || fail "$bad should be rejected"
done
total=$((total + 1))
helm template t . --set gn5.enabled=true --set gn46.max_upload_size=53687091200 2>&1 | grep -q '^Error' \
  && fail "gn46.max_upload_size=53687091200 (50 GiB) should be accepted"

expect_accepted /var/local/gis_sdi/tmp/gn46
expect_accepted /var/local/gis_sdi/tmp/gn46/
expect_accepted /var/local/gis_sdi/tmp/a/b_c-d.e

expect_rejected /
expect_rejected /var
expect_rejected /var/local/gis_sdi
expect_rejected /var/local/gis_sdi/
expect_rejected /var/local/gis_sdi/tmp
expect_rejected /var/local/gis_sdi/tmp/
expect_rejected /var/local/gis_sdi/tmp//
expect_rejected /var/local/gis_sdi/tmp/.
expect_rejected /var/local/gis_sdi/tmp/./x
expect_rejected /var/local/gis_sdi/tmp/../cataloguestore
expect_rejected /var/local/gis_sdi/tmp/gn46/../..
total=$((total + 1))
render /var/local/gis_sdi/tmp/gn46/../.. | grep -q 'gn46.tmpdir must be a subdirectory' \
  || fail "the template guard should reject .. even if the schema pattern accepts it"
expect_rejected /var/local/gis_sdi/tmpx/gn46
expect_rejected /var/local/gis_sdi/cataloguestore
expect_rejected tmp/gn46
expect_rejected '/var/local/gis_sdi/tmp/a b'
expect_rejected '/var/local/gis_sdi/tmp/a;rm -rf /'
expect_rejected '/var/local/gis_sdi/tmp/a$(id)'
expect_rejected '/var/local/gis_sdi/tmp/a"b'

if [ "$failures" -ne 0 ]; then
  echo "$failures of $total checks failed"
  exit 1
fi
echo "OK: $total checks passed"
