# CCA Backend

Helm chart for the Climate-ADAPT backend stack.

The chart follows the conventions already used in this repository for Plone
backends and adds the CCA-specific supporting services from the Rancher stack:
`plone-translate`, `redis`, `async`, `converter`, `zodbpack`
and the broken-links cron job.

Sensitive values are intentionally left empty in `values.yaml`.
## Releases

### Version 0.2.23 - 09 April 2026
- relax plone health probes to avoid restarts during long broken-links scans

### Version 0.2.22 - 08 April 2026
- change docker image to test the latest changes [Dobricean Ioan Dorian - [`6b847b70`](https://github.com/eea/helm-charts/commit/6b847b70abe9aa9a7f2d3b85dda8925e256bc8c9)]

### Version 0.2.21 - 02 April 2026
- remove dependency on pv [Dobricean Ioan Dorian - [`8596ea09`](https://github.com/eea/helm-charts/commit/8596ea091aaa4d8b144b5fe3f7a9e53532013745)]

### Version 0.2.20 - 02 April 2026
- change app version [Dobricean Ioan Dorian - [`e13c6e0e`](https://github.com/eea/helm-charts/commit/e13c6e0ec5432d762ea3291e0d32e5d7a473db2a)]

### Version 0.2.19 - 02 April 2026
- remove hardcoded image [Dobricean Ioan Dorian - [`daefb85e`](https://github.com/eea/helm-charts/commit/daefb85e6cf9a3e06f8eedf46439a72d9f4b9127)]

### Version 0.2.18 - 02 April 2026
- fix entrasync and zodbpack [Dobricean Ioan Dorian - [`0ca45b93`](https://github.com/eea/helm-charts/commit/0ca45b93d67426ee0cb91e9039295f9df7c77632)]

### Version 0.2.17 - 02 April 2026
- Fix zodbpack [Dobricean Ioan Dorian - [`3d670d7c`](https://github.com/eea/helm-charts/commit/3d670d7cc7a827a19cdd8ffa56b2ea40460e4537)]

### Version 0.2.16 - 02 April 2026
- fix zodbpack [Dobricean Ioan Dorian - [`57511646`](https://github.com/eea/helm-charts/commit/57511646d01c8617cc37516eeec1be9d3027c0ba)]

### Version 0.2.15 - 02 April 2026
- add entrasync corn job [Dobricean Ioan Dorian - [`e7b207ad`](https://github.com/eea/helm-charts/commit/e7b207ada67d1d133de738f1463b12d8b79c8901)]

### Version 0.2.14 - 02 April 2026
- remove /admin [Dobricean Ioan Dorian - [`2b135d01`](https://github.com/eea/helm-charts/commit/2b135d0138f37c39e8bf9cd00aa73591af91e19f)]

### Version 0.2.13 - 02 April 2026
- add debug instance [Dobricean Ioan Dorian - [`d1226659`](https://github.com/eea/helm-charts/commit/d1226659f492213080bcfce32c6fadf30c0ce9bb)]

### Version 0.2.12 - 26 March 2026
- memory [Dobricean Ioan Dorian - [`b61a123c`](https://github.com/eea/helm-charts/commit/b61a123c52578b501404fff6100466592c63e346)]

### Version 0.2.10 - 25 March 2026
- align service with other backens [Dobricean Ioan Dorian - [`f4bd16fe`](https://github.com/eea/helm-charts/commit/f4bd16fe562264ef5c8635da583369653efbdfba)]

### Version 0.2.9 - 25 March 2026
- fix ingress [Dobricean Ioan Dorian - [`203532de`](https://github.com/eea/helm-charts/commit/203532de9c134331137e4d170d1ed60c2605f8c6)]

### Version 0.2.8 - 25 March 2026
- ingress [Dobricean Ioan Dorian - [`c31fab65`](https://github.com/eea/helm-charts/commit/c31fab6576b8db5bab270766a6ee9f13b1923b7d)]

### Version 0.2.7 - 25 March 2026
- fix ingresses [Dobricean Ioan Dorian - [`15f96814`](https://github.com/eea/helm-charts/commit/15f9681417ca5af45c4229a9667462f1bc708a36)]

### Version 0.2.6 - 13 March 2026
- remove memcache [Dobricean Ioan Dorian - [`d810cf06`](https://github.com/eea/helm-charts/commit/d810cf06b6ad32c0bb3ebb6978b6a248793a2f4f)]

### Version 0.2.4 - 13 March 2026
- align to deafult plone ingress [Dobricean Ioan Dorian - [`96ec0111`](https://github.com/eea/helm-charts/commit/96ec0111414ef54c7630cec54a39a71b6e347fc3)]

### Version 0.2.2 - 13 March 2026
- change questions [Dobricean Ioan Dorian - [`d02e405a`](https://github.com/eea/helm-charts/commit/d02e405af2aebb1f6dee9cae7e2f6e172615db11)]
