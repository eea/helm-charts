# copernicus-qc-tool

Helm chart for the QC Tool stack migrated from Rancher 1 / docker-compose.

Notes:

- the passwords from the compose files are not copied; the required passwords are configured directly through chart values and Rancher questions
- `volume-tester` is kept as an optional workload and is disabled by default
- for `nextcloudAppData` the chart uses the claim name `qc_tool_nextcloud_appdata`, because that is the volume name mounted by the provided stack
- the default frontend hostname is `dev-qc-copernicus.01dev.eea.europa.eu` and can be changed from `questions.yaml`
- frontend public/API URLs and CSRF origins can be configured with `frontend.publicUrl`, `frontend.apiUrl`, and `frontend.csrfTrustedOrigins`
- Nextcloud public URL and trusted domains can be configured with `nextcloud.publicUrl` and `nextcloud.trustedDomains`
- PostgreSQL is expected to be deployed separately, for example with `plone-postgres`; the frontend connects to the service configured in `links.database`
- MariaDB exposes the release-specific service and a `db` compatibility alias for existing Nextcloud configs
- existing Nextcloud `config.php` files are synced with the chart database, Redis, and trusted domain values before startup
- email delivery is handled through the shared `postfix` subchart, with the same `dryrun` and `mailtrap` options used by other EEA applications

Required password values:

- `frontend.database.password`
- `mariadb.database.password`
- `mariadb.database.rootPassword`
- `postfix.mtpPass`
## Releases

### Version 0.1.22 - 25 June 2026
- fix [Dobricean Ioan Dorian - [`255c78aa`](https://github.com/eea/helm-charts/commit/255c78aab2f2b2c699766ddcaf010b7e23a6b969)]

### Version 0.1.21 - 25 June 2026
- expose frontend, CSRF, worker INSPIRE, and Nextcloud URL settings as chart values [Codex]

### Version 0.1.20 - 24 June 2026
- fix [Dobricean Ioan Dorian - [`c7a9b5e9`](https://github.com/eea/helm-charts/commit/c7a9b5e9c29896be90283845c40c237b928968a6)]

### Version 0.1.19 - 24 June 2026
- update frontend and worker image tags to 2.4.3 [Codex]

### Version 0.1.18 - 23 June 2026
- fix [Dobricean Ioan Dorian - [`02bb60a7`](https://github.com/eea/helm-charts/commit/02bb60a7eb9ba65ee9ad7e2eb423e484cd9e6465)]

### Version 0.1.17 - 23 June 2026
- use `links.database` directly for frontend PostgreSQL host [Codex]

### Version 0.1.16 - 23 June 2026
- fix [Dobricean Ioan Dorian - [`10a4e5a6`](https://github.com/eea/helm-charts/commit/10a4e5a6ab22a88a03d2c630df6e6fe4326730b8)]

### Version 0.1.15 - 23 June 2026
- sync existing Nextcloud config.php with chart values before startup [Codex]

### Version 0.1.14 - 23 June 2026
- fix [Dobricean Ioan Dorian - [`0554361c`](https://github.com/eea/helm-charts/commit/0554361ca31d2b286ffb3640ecb4135a0b7ed595)]

### Version 0.1.13 - 23 June 2026
- add MariaDB `db` service alias for existing Nextcloud configs [Codex]

### Version 0.1.12 - 22 April 2026
- fix database [Dobricean Ioan Dorian - [`24fa75bf`](https://github.com/eea/helm-charts/commit/24fa75bf2c7bf1cc3ced761b749da66d997769d4)]

### Version 0.1.11 - 22 April 2026
- point the internal PostgreSQL alias service to the existing postgres service in the qc-tool namespace [Codex]

### Version 0.1.10 - 22 April 2026
- fix postgres comunication [Dobricean Ioan Dorian - [`5dc3d5f2`](https://github.com/eea/helm-charts/commit/5dc3d5f23d9e439650d896dfb0fe36777e1a09b6)]

### Version 0.1.9 - 22 April 2026
- use a stable local PostgreSQL alias service name, matching backend chart conventions [Codex]

### Version 0.1.8 - 20 April 2026
- fix clustter issuer [Dobricean Ioan Dorian - [`9d694fde`](https://github.com/eea/helm-charts/commit/9d694fde9b7e5b09ff2249f9b7737682ef71c66c)]

### Version 0.1.7 - 20 April 2026
- add letsencrypt cluster issuer defaults for frontend and nextcloud ingresses [Codex]

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
