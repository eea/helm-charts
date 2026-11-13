## Releases

### Version 0.20.0 - 13 November 2026
- Automated release of [eeacms/redmine-wikiman:2.1.26](https://github.com/eea/eea.docker.redmine-wikiman/releases) [EEA Jenkins - [`9ef9d7335`](https://github.com/eea/helm-charts/commit/9ef9d73356f985ada29a2acff8575a55fc34740c)]

### Version 0.19.0 - 13 November 2026
- Fix 01dev crash loop: git repository setup is no longer run during `initialize_components` (it blocked the HTTP server bind and, on a fresh volume, the full ~115 MB clone outlived the startup probe, so each restart re-ran an oversized clone and the pod died exit 137). Setup now runs in the background after the server serves `/health`; clone/fetch/push are subprocess steps capped by `GIT_SETUP_TIMEOUT_SECONDS` (default 600s); a hollow repo (no usable refs, e.g. a killed mid-clone) is wiped and re-cloned. Requires image `eeacms/redmine-wikiman:backup-2.1.25` [Silviu Panaite]

### Version 0.18.0 - 13 November 2026
- upgradeNotify: add `clusterUrl` (cluster ingress link in the card), `releaseNotes` toggle and `githubToken` (git-based release notes, best-effort); split liveness/readiness probes with startup grace (2026-11-09 restart-storm fix) [Silviu Panaite]

### Version 0.17.0 - 05 November 2026
- Add upgrade notifications (#310015): taskman-backup posts Helm release install/upgrade/rollback cards to the Upgrades (DevOps) room via matrix-webhook. New `upgradeNotify` values (`enabled`, `webhookUrl`, `cluster`, `interval`), off by default; requires image `eeacms/redmine-wikiman:backup-2.1.24` [Silviu Panaite]

### Version 0.16.1 - 27 October 2026
- allow env variables in the deployment for backup config [Mihai Dobrescu - [`e241a4c45`](https://github.com/eea/helm-charts/commit/e241a4c45dd7a7b568bb2eb42dd4bb0dfc97a632)]

### Version 0.16.0 - 03 September 2026
- Automated release of [eeacms/redmine-wikiman:2.1.23](https://github.com/eea/eea.docker.redmine-wikiman/releases) [EEA Jenkins - [`5706f21e`](https://github.com/eea/helm-charts/commit/5706f21efa1d5b291cdbdad8bbca6c142ddefabd)]

### Version 0.15.0 - 31 August 2026
- Automated release of [eeacms/redmine-wikiman:2.1.22](https://github.com/eea/eea.docker.redmine-wikiman/releases) [EEA Jenkins - [`1f7bcb3d`](https://github.com/eea/helm-charts/commit/1f7bcb3de0138be1b4ad758698b3047646f2aca1)]

### Version 0.14.0 - 22 July 2026
- Automated release of [eeacms/redmine-wikiman:2.1.21](https://github.com/eea/eea.docker.redmine-wikiman/releases) [EEA Jenkins - [`ea0971b8`](https://github.com/eea/helm-charts/commit/ea0971b813932d9535bd3fb6df6607341702c00c)]

### Version 0.13.0 - 17 July 2026
- Automated release of [eeacms/redmine-wikiman:2.1.20](https://github.com/eea/eea.docker.redmine-wikiman/releases) [EEA Jenkins - [`3963150d`](https://github.com/eea/helm-charts/commit/3963150d2ab4254afb56d06fd826003035e9ebdf)]

### Version 0.12.0 - 17 July 2026
- Automated release of [eeacms/redmine-wikiman:2.1.19](https://github.com/eea/eea.docker.redmine-wikiman/releases) [EEA Jenkins - [`f741ea22`](https://github.com/eea/helm-charts/commit/f741ea22ed0c701c1652472d5acc74671ccdf955)]

### Version 0.11.0 - 16 July 2026
- Automated release of [eeacms/redmine-wikiman:2.1.18](https://github.com/eea/eea.docker.redmine-wikiman/releases) [EEA Jenkins - [`24e42bb6`](https://github.com/eea/helm-charts/commit/24e42bb6f4683ec64163812e1d9472f4b642ac5f)]

### Version 0.10.0 - 16 July 2026
- Automated release of [eeacms/redmine-wikiman:2.1.17](https://github.com/eea/eea.docker.redmine-wikiman/releases) [EEA Jenkins - [`6d29e265`](https://github.com/eea/helm-charts/commit/6d29e265f3eb1fdf8768476a1dafefa811587c76)]

### Version 0.9.0 - 13 July 2026
- Automated release of [eeacms/redmine-wikiman:2.1.16](https://github.com/eea/eea.docker.redmine-wikiman/releases) [EEA Jenkins - [`57d4548a`](https://github.com/eea/helm-charts/commit/57d4548ae82aa162d1d932ef4730909c54457335)]

### Version 0.8.0 - 13 July 2026
- Automated release of [eeacms/redmine-wikiman:2.1.15](https://github.com/eea/eea.docker.redmine-wikiman/releases) [EEA Jenkins - [`638493c3`](https://github.com/eea/helm-charts/commit/638493c369a108cace196944f44439ba75c44b96)]

### Version 0.7.0 - 13 July 2026
- Automated release of [eeacms/redmine-wikiman:2.1.14](https://github.com/eea/eea.docker.redmine-wikiman/releases) [EEA Jenkins - [`77d0fa4c`](https://github.com/eea/helm-charts/commit/77d0fa4cba142555fcaf7270c71aa4df7f277904)]

### Version 0.6.0 - 21 January 2026
- Automated release of [eeacms/redmine-wikiman:2.1.13](https://github.com/eea/eea.docker.redmine-wikiman/releases) [EEA Jenkins - [`e99be864`](https://github.com/eea/helm-charts/commit/e99be86493ac1b2877c92ae5c1d052a702d7d575)]

### Version 0.5.0 - 14 January 2026
- Automated release of [eeacms/redmine-wikiman:2.1.12](https://github.com/eea/eea.docker.redmine-wikiman/releases) [EEA Jenkins - [`ee3ee082`](https://github.com/eea/helm-charts/commit/ee3ee08273192eb3427d708ece41f259ecc936f7)]

### Version 0.4.0 - 14 January 2026
- Automated release of [eeacms/redmine-wikiman:2.1.11](https://github.com/eea/eea.docker.redmine-wikiman/releases) [EEA Jenkins - [`123559c5`](https://github.com/eea/helm-charts/commit/123559c594e252a2093215300050540aefcb97d0)]

### Version 0.3.0 - 14 January 2026
- Automated release of [eeacms/redmine-wikiman:2.1.10](https://github.com/eea/eea.docker.redmine-wikiman/releases) [EEA Jenkins - [`31076656`](https://github.com/eea/helm-charts/commit/3107665658832c4f18fc58577973e01d550adac2)]

### Version 0.2.0 - 14 January 2026
- Automated release of [eeacms/redmine-wikiman:2.1.9](https://github.com/eea/eea.docker.redmine-wikiman/releases) [EEA Jenkins - [`8a664128`](https://github.com/eea/helm-charts/commit/8a6641281b079a461d036805163626c10daf6ec8)]

