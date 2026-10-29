# Logcentral Graylog 

This Helm chart deploys Graylog for the centralized logging solution. It wraps the official
[Graylog Helm chart](https://github.com/Graylog2/graylog-helm) (`graylog` 2.1.0, run with Graylog 7.2.1 through
`graylog.version`) and the
`postfix` chart of this repository, runs its own MongoDB replica set, and connects Graylog to an
**existing OpenSearch cluster** (`logcentral-opensearch1`). The Graylog Data Node is not used.

## Layout of the values

| Path | What it configures |
|------|--------------------|
| `graylog.graylog.*` | Graylog server nodes (one StatefulSet of identical nodes, automatic leader election) |
| `graylog.opensearch.*` | The existing OpenSearch cluster (`datanode.enabled` must stay `false`) |
| `mongodb.*` | This chart's MongoDB replica set (`graylog.mongodb` only switches the official chart's off) |
| `passwordSecret`, `rootPassword`, `rootPasswordSha2` | Graylog secrets (see Credentials) |
| `inputsService.*` | Service for the Graylog inputs: LoadBalancer (production) or NodePort (pre) |
| `ingress.*` | Web UI ingress, as in logcentral-graylog5: empty `className` = default class, empty `tls.secretName` = the controller's default certificate, annotations passed through |
| `postfix.*` | Mail relay. `postfix.serviceName` must match `graylog.graylog.config.email.hostname` |

Environment specifics and secrets are **not** in this chart's `values.yaml` (public repository).

## What gets installed

Everything is namespaced: the chart installs with namespace rights only (no CRDs, ClusterRoles or
operator), in any namespace, one release per namespace.

- **MongoDB**: StatefulSet `<release>-mongodb` (official `mongo` image, 7.0), `mongodb.replicas`
  members (default 3) with keyfile auth. The `rs-manager` sidecar of member 0 initiates the replica
  set, creates the users `root` and `graylog` and, every 30 s, adds or removes members to match
  `mongodb.replicas` (one member per pass). Scaling below a majority (e.g. 3 to 1) leaves no primary
  for a moment; the sidecar then force-reconfigures to the remaining members.
  Logs: `kubectl logs <release>-mongodb-0 -c rs-manager`.
- **Graylog**: the official chart with `global.existingSecretName: logcentral-graylog-secrets`; this
  chart writes that Secret (MongoDB URI, root user, `password_secret`).
- **Postfix**, and the **inputs Service** (below).
- Required outside this chart: OpenSearch 2.x up to 2.19.x reachable from the namespace
  (`graylog.opensearch.hosts`); `action.auto_create_index: false` is recommended on it.

## Credentials

Generated values are read back from the cluster on every upgrade, so they never change once created.
`<release>-mongodb` and `logcentral-graylog-secrets` are kept on `helm uninstall` (the MongoDB volumes
outlive the release and hold users with these passwords).

- `passwordSecret`: Graylog `password_secret`, >= 16 characters. When migrating from
  `logcentral-graylog5` it must be that release's `global.adminPassword`: the old chart passed it raw as
  `GRAYLOG_PASSWORD_SECRET`, which wins over the hashed value in its `graylog.conf`. Encrypted values
  in the restored MongoDB (input, OpenSearch and mail credentials) are unreadable under another one.
  Empty = generated (fresh installation only).
- `rootPassword` (plain) or `rootPasswordSha2` (SHA-256 hex): the Graylog root login. Use the old
  release's `global.rootPassword` as `rootPasswordSha2` to keep the same admin login. Both empty =
  generated, readable in Secret `<release>-mongodb`, key `graylog-root-password`.
- MongoDB root and graylog passwords and the keyfile: generated, in Secret `<release>-mongodb`. The
  `mongodb` container has `$MONGO_ROOT_PASSWORD` for admin shells (see the NOTES after install).

## Inputs

The inputs get their own Service, `<release>-inputs` (`inputsService`), carrying the ports of
`graylog.graylog.inputs` (syslog 1514, GELF 12201 and 12202, TCP and UDP) and not the web port.

- **Production**: `inputsService.type: LoadBalancer`, as the old chart (`graylogClient.lb.exposeIP`).
  Set `inputsService.loadBalancerIP` to the old address so that log senders need no change; the old
  LoadBalancer must be removed first, or MetalLB cannot hand the address over.
  Mixing TCP and UDP on one LoadBalancer needs Kubernetes 1.26+, as for the old chart.
- **Pre**: `inputsService.type: NodePort`. Node ports are random unless fixed in
  `inputsService.nodePorts` by input name, e.g. `{syslog-tcp: 31514, syslog-udp: 31514}`.

## Migration from logcentral-graylog5

Tested on 02pre (Graylog 6.3.15 + MongoDB 5.0 to this chart, release `graylog7` next to the old
release `graylog` in the same namespace). Graylog 7 needs MongoDB 7.0, so the data is moved with a
logical dump; the old MongoDB is never changed, which keeps rollback simple.

1. Install this chart with `graylog.graylog.replicas: 0`, `ingress.enabled: false`,
   `inputsService.enabled: false`, `passwordSecret` / `rootPasswordSha2` from the old release, and
   `postfix.serviceName` + `graylog.graylog.config.email.hostname` set to e.g. `postfix7` (the old
   release owns the Service `postfix`). The old Graylog keeps running; wait until
   `kubectl logs <release>-mongodb-0 -c rs-manager` shows all members added.
2. Stop the old Graylog: scale `<old>-graylog-master` and `<old>-graylog-client` to 0. Two Graylog
   clusters must never manage the same OpenSearch indices. Ingestion stops from here until step 5.
3. Dump the old database and restore it (about 2 minutes for 120 MB on 02pre):
   ```sh
   kubectl -n <ns> exec <old>-mongodb-0 -- mongodump --quiet --db graylog --archive --gzip > graylog.archive.gz
   M=$(kubectl -n <ns> get sts <release>-mongodb -o jsonpath='{.spec.template.spec.containers[1].env[?(@.name=="RS_MEMBERS")].value}')
   kubectl -n <ns> exec -i <release>-mongodb-0 -c mongodb -- bash -c \
     "mongorestore --uri \"mongodb://root:\$MONGO_ROOT_PASSWORD@$M/?replicaSet=rs0&authSource=admin\" --archive --gzip --drop --nsInclude 'graylog.*'" \
     < graylog.archive.gz
   ```
4. Set `graylog.graylog.replicas: 4` and upgrade. On first start Graylog 7 migrates the data forward
   (one-way: keep the dump); the cluster ID shown on `/api/` is the old one.
5. Move the web UI and inputs: upgrade the old release with `ingress.enabled: false` (and both Graylog
   replicas at 0, or the upgrade starts them again), delete its inputs Service, then enable
   `ingress` and `inputsService` here (NodePort: same `inputsService.nodePorts`; LoadBalancer:
   same `inputsService.loadBalancerIP`).
6. Rollback until the old release is removed: scale this release's Graylog to 0, the old StatefulSets
   back up, and restore the old Ingress and inputs Service.

## Changing password_secret

Graylog has no tool for it: `password_secret` encrypts values in MongoDB (LDAP bind password, input
TLS key passwords, notification and lookup credentials, ...), the API access tokens and a check value
that Graylog verifies at startup ("Invalid password_secret!"), and salts legacy SHA-1 user passwords.
`scripts/rotate-password-secret.js` (mongosh, not packaged) re-encrypts all of it from the old secret
to a new one, keeps existing access tokens working and lists SHA-1 users whose password must be reset.
Login sessions end. Tested on 02pre (Graylog 7.1.8 to 7.2.1, LDAP backend and 2 access tokens).

With every Graylog node stopped (`graylog.graylog.replicas: 0`) and a dump taken:

```sh
kubectl -n <ns> cp scripts/rotate-password-secret.js <release>-mongodb-0:/tmp/rotate.js -c mongodb
M=$(kubectl -n <ns> get sts <release>-mongodb -o jsonpath='{.spec.template.spec.containers[1].env[?(@.name=="RS_MEMBERS")].value}')
# two lines on stdin: old secret, new secret (keeps them out of command lines)
cat old-secret new-secret | kubectl -n <ns> exec -i <release>-mongodb-0 -c mongodb -- bash -c \
  "read -r OLD; read -r NEW; for MODE in check apply; do OLD_SECRET=\"\$OLD\" NEW_SECRET=\"\$NEW\" MODE=\$MODE \
   mongosh --quiet \"mongodb://root:\$MONGO_ROOT_PASSWORD@$M/graylog?replicaSet=rs0&authSource=admin\" \
   --eval 'load(\"/tmp/rotate.js\")' </dev/null || exit 1; done"
```

`check` decrypts everything with the old secret and writes nothing; `apply` re-encrypts and verifies
with the new one. Both print the same `fingerprint` when the contents are unchanged. Then set
`passwordSecret` to the new secret and start Graylog. When migrating from logcentral-graylog5, do this
between restoring the dump and starting Graylog (step 3 and 4 of the migration).

## GeoIP

With `geoip.enabled` and the MaxMind account in `geoip.accountId` / `geoip.licenseKey` (the matomo
chart's account), the chart downloads GeoLite2 City and ASN into the ReadWriteMany volume
`logcentral-graylog-geoip`, mounted read-only in every Graylog pod at `/usr/share/graylog/geoip/`:
a Job right after each install/upgrade, then a CronJob on `geoip.schedule` (daily; geoipupdate only
fetches editions that changed). Point Graylog's MaxMind data adapters there (System > Lookup Tables >
Data Adapters), e.g. `/usr/share/graylog/geoip/GeoLite2-City.mmdb`; logcentral-graylog5 used
`/usr/share/graylog/data/geolite/`. The volume exists even with GeoIP off (the pods always mount it).

## Load balancing on overload

Graylog's `/api/system/lbstatus` returns 200 ALIVE, 429 THROTTLED or 503 DEAD. A node turns THROTTLED
when its journal passes `GRAYLOG_LB_THROTTLE_THRESHOLD_PERCENTAGE` (10 here; Graylog's default 100
means "only when full") and back to ALIVE below it, checked every 60 s.

The readiness probe (`graylog.graylog.readinessProbe`, a shell script in `values.yaml`) turns that into
Service membership: ALIVE is ready, DEAD is not, THROTTLED is not ready only while another node is
ALIVE. When every node is throttled (typically OpenSearch is slow) they all stay ready, so the inputs
and the web UI keep their endpoints. The startup probe accepts ALIVE or THROTTLED, so a node restarting
with a full journal is not killed.

Graylog has no backpressure for TCP or UDP inputs: the inputs' "Allow throttling this input"
option only works for pull inputs (Kafka, AMQP, HTTP polling). Tested on 7.2.1, a TCP input kept
reading at 25,000 msg/s into a node that had stopped processing. A flood is only bounded by the
journal (when full, Graylog deletes the oldest unprocessed messages) or by limits at the senders.

Kubernetes only steers new connections away from an unready pod: long-lived TCP senders and ongoing
UDP flows stay on the throttled node. To test, force one node (port-forward to that pod):
`curl -u admin -X PUT -H 'X-Requested-By: test' http://localhost:9000/api/system/lbstatus/override/throttled`
and back with `.../override/alive`.

## Notes

- Inputs created as non-Global in the old installation are tied to the old node IDs and do not start
  on the new nodes. Re-create them as Global.
- The journal of each node lives on its own PVC. Drain the old installation's journals before cutover.
- `postfix.dryrun: true` runs the mailtrap image (mail is caught, not delivered), which is what the old
  chart deployed. Set it to `false` to relay through `postfix.mtpRelay`.
- `mongodb.persistence.storageClass: nfs-client` is kept from the old chart; MongoDB's storage engine
  does better on block storage. Graylog warns that its journal is on NFS, as the old chart's was.

## Releases

### Version 1.0.5 - 29 October 2026
- OpenSearch request timeout raised from 60 s to 5 minutes (`GRAYLOG_ELASTICSEARCH_SOCKET_TIMEOUT`). On production the message-count histogram over 30 days takes about 55 s; anything slower failed with the widget error "null"
- Ingress nginx settings in `ingress.configuration`, as in the other EEA charts: proxy read/send timeout 360 s (nginx default 60 s), so synchronous searches and CSV exports are not cut off by the ingress before Graylog's 5 minutes, and body size 100m (nginx default 1m) for content pack uploads

### Version 1.0.4 - 29 October 2026
- Message journal 80gb per node (was 40gb) on a 90Gi volume: about 170M messages, the only buffer against floods because Graylog's TCP/UDP inputs have no backpressure. The volume size of an existing StatefulSet cannot change: existing releases keep their size (set graylog.graylog.persistence.size and messageJournal.maxSize to the old values) or recreate the StatefulSet
- Graylog heap fixed at 4g in 8Gi pods (CPU request 2), stream-aware field types off (on by default in 7.2). Tested on 02pre and not adopted: output batches of 10mb took twice as long as the default 500 messages, and 8 instead of 20 process buffer processors gained nothing
- `GRAYLOG_TRUSTED_PROXIES` includes the RKE pod network (10.42.0.0/16), so Graylog records the users' IPs from X-Forwarded-For instead of the ingress controller's
- Load balancer throttling at 10% journal usage (was 25%): about 17M messages, or ~14 minutes of indexing lag on one node, before it steps out of the Services

### Version 1.0.3 - 28 October 2026
- GeoLite2 downloads moved from the official chart's per-pod sidecar to one CronJob (plus a Job after each install/upgrade) writing to a shared volume mounted at `/usr/share/graylog/geoip/`. The sidecar ignored SIGTERM, so every Graylog pod waited out its 300 s grace period on each restart, and it only downloaded at midnight. Switch on with `geoip.enabled` (was `graylog.graylog.config.geolocation.enabled`) and repoint the MaxMind data adapters to the new path

### Version 1.0.2 - 28 October 2026
- MongoDB pods restart only when the replica set scripts change, no longer on every chart version (the checksum covered the ConfigMap's labels, which carry the chart version)

### Version 1.0.1 - 28 October 2026
- GeoLite2 City and ASN databases for the Graylog GeoIP lookup tables: the official chart's geoipupdate sidecar (`graylog.graylog.config.geolocation.enabled`), with the MaxMind account in `geoip.accountId` / `geoip.licenseKey` (Secret `logcentral-graylog-maxmind`)

### Version 1.0.0 - 28 October 2026
- Initial release: official Graylog chart 2.1.0 with Graylog 7.2.1 (`graylog.version`) with external OpenSearch, a MongoDB 7.0 replica set run by this chart (no operator, namespace rights only), and the postfix chart
- `passwordSecret` / `rootPassword` / `rootPasswordSha2` to keep or replace the secrets of `logcentral-graylog5`; `scripts/rotate-password-secret.js` to change `password_secret` on existing data
- Web UI Ingress like `logcentral-graylog5` (default class, TLS with the controller's default certificate), and a Service for the inputs (LoadBalancer or NodePort)
- Readiness follows Graylog's load balancer status: a node with its journal over 25% leaves the Services unless every node does
