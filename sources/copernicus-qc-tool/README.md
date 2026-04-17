# copernicus-qc-tool

Helm chart for the QC Tool stack migrated from Rancher 1 / docker-compose.

Notes:

- the passwords from the compose files are not copied; the chart uses a `Secret` with neutral placeholders or an `existingSecret`
- `volume-tester` is kept as an optional workload and is disabled by default
- for `nextcloudAppData` the chart uses the claim name `qc_tool_nextcloud_appdata`, because that is the volume name mounted by the provided stack
- the default frontend hostname is `dev-qc-copernicus.01dev.eea.europa.eu` and can be changed from `questions.yaml`
- PostgreSQL is expected to be deployed separately, for example with `plone-postgres`; this chart only stores the connection settings and creates an internal alias service

Required secret keys:

- `postgres-password`
- `mariadb-password`
- `mariadb-root-password`
- `smtp-password`
