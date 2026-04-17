# copernicus-qc-tool

Helm chart for the QC Tool stack migrated from Rancher 1 / docker-compose.

Notes:

- the passwords from the compose files are not copied; the required passwords are configured directly through chart values and Rancher questions
- `volume-tester` is kept as an optional workload and is disabled by default
- for `nextcloudAppData` the chart uses the claim name `qc_tool_nextcloud_appdata`, because that is the volume name mounted by the provided stack
- the default frontend hostname is `dev-qc-copernicus.01dev.eea.europa.eu` and can be changed from `questions.yaml`
- PostgreSQL is expected to be deployed separately, for example with `plone-postgres`; this chart only stores the connection settings and creates an internal alias service
- email delivery is handled through the shared `postfix` subchart, with the same `dryrun` and `mailtrap` options used by other EEA applications

Required password values:

- `frontend.database.password`
- `mariadb.database.password`
- `mariadb.database.rootPassword`
- `postfix.mtpPass`
## Releases

### Version 0.1.6 - 17 April 2026
- fix health check [Dobricean Ioan Dorian - [`46ff8efd`](https://github.com/eea/helm-charts/commit/46ff8efd6d60c91d6463819ff9f99df88ab51c55)]

### Version 0.1.5 - 17 April 2026
- fix pv [Dobricean Ioan Dorian - [`1882e731`](https://github.com/eea/helm-charts/commit/1882e731f018ed99d711331b2928544580918cac)]

### Version 0.1.4 - 17 April 2026
- postfix [Dobricean Ioan Dorian - [`98e23468`](https://github.com/eea/helm-charts/commit/98e2346848430da946b0b6a2a3a4f98ec1be0924)]

### Version 0.1.3 - 17 April 2026
- fix pvc [Dobricean Ioan Dorian - [`bb90d8ac`](https://github.com/eea/helm-charts/commit/bb90d8acf47ad70bd468437eb9e6e8f30cb88caf)]

### Version 0.1.2 - 17 April 2026
- add passwords vars [Dobricean Ioan Dorian - [`a6737c7b`](https://github.com/eea/helm-charts/commit/a6737c7b5c6de972d4d70d240707d5d21cf93c30)]

### Version 0.1.1 - 17 April 2026
- first release [Dobricean Ioan Dorian - [`d400cade`](https://github.com/eea/helm-charts/commit/d400cadefab101dd41caaad74f6d48d15e2b4337)]
