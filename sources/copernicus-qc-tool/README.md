# copernicus-qc-tool

Helm chart for the QC Tool stack migrated from Rancher 1 / docker-compose.

Notes:

- the passwords from the compose files are not copied; the required passwords are configured directly through chart values and Rancher questions
- `volume-tester` is kept as an optional workload and is disabled by default
- for `nextcloudAppData` the chart uses the claim name `qc_tool_nextcloud_appdata`, because that is the volume name mounted by the provided stack
- the default frontend hostname is `dev-qc-copernicus.01dev.eea.europa.eu` and can be changed from `questions.yaml`
- PostgreSQL is expected to be deployed separately, for example with `plone-postgres`; this chart only stores the connection settings and creates an internal alias service

Required password values:

- `frontend.database.password`
- `mariadb.database.password`
- `mariadb.database.rootPassword`
- `postfix.mtpPass`
## Releases

### Version 0.1.1 - 17 April 2026
- first release [Dobricean Ioan Dorian - [`d400cade`](https://github.com/eea/helm-charts/commit/d400cadefab101dd41caaad74f6d48d15e2b4337)]
