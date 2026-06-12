# CCA Backend

Helm chart for the Climate-ADAPT backend stack.

The chart follows the conventions already used in this repository for Plone
backends and adds the CCA-specific supporting services from the Rancher stack:
`plone-translate`, `redis`, `async`, `converter`, `zodbpack`
and the broken-links cron job.

Sensitive values are intentionally left empty in `values.yaml`.
## Releases

### Version 0.6.2 - 12 June 2026
- upgrade to v11.0.15-plone6.1 [Tiberiu Ichim - [`1364e9e4`](https://github.com/eea/helm-charts/commit/1364e9e47bc6e8f9095edf24ce8d71f6b219249d)]

### Version 0.6.1 - 11 June 2026
- Upgrade to v11.0.13-plone6.1 [Tiberiu Ichim - [`fd6c36e7`](https://github.com/eea/helm-charts/commit/fd6c36e7f236ce6ae649bd7b06453ea798270412)]

### Version 0.6.0 - 10 June 2026
- Upgrade to backend v11.0.11-plone6.1 [Tiberiu Ichim - [`f22b0899`](https://github.com/eea/helm-charts/commit/f22b0899bf76a0ca06d82fedeb0a7b920e38173c)]

### Version 0.5.0 - 09 June 2026
- upgrade to v11.0.10-plone6.1 [Tiberiu Ichim - [`d2ef248f`](https://github.com/eea/helm-charts/commit/d2ef248f6bad5c5561c723c10d8d40f4309edcad)]

### Version 0.4.1 - 04 June 2026
- add convertor [Dobricean Ioan Dorian - [`d45d633e`](https://github.com/eea/helm-charts/commit/d45d633ed9f743f99cdb00dab9db4d2bc80edaee)]

### Version 0.4.0 - 25 May 2026
- Upgrade backend [Tiberiu Ichim - [`13f3b5b4`](https://github.com/eea/helm-charts/commit/13f3b5b4926a53e1fbd28df05af0fe7b50fca20e)]

### Version 0.3.0 - 25 May 2026
- Sync for Rancher 2 deployment [Tiberiu Ichim - [`00b99718`](https://github.com/eea/helm-charts/commit/00b9971822628992b1dc099186bbf7d1e8b2a112)]

### Version 0.2.30 - 14 May 2026
- add missing vars [Dobricean Ioan Dorian - [`d9debafa`](https://github.com/eea/helm-charts/commit/d9debafaa4be711863a1e96a909a47441ca85642)]

### Version 0.2.29 - 28 April 2026
- update image and ingresses [Dobricean Ioan Dorian - [`53687a01`](https://github.com/eea/helm-charts/commit/53687a0188f0dcb85da13dd3e85c33ef96d9fe67)]

### Version 0.2.28 - 23 April 2026
- move to offical eea image [Dobricean Ioan Dorian - [`b8102bd7`](https://github.com/eea/helm-charts/commit/b8102bd7bb7391c7ee0a2ef3b2f3e99075d45a29)]

### Version 0.2.26 - 09 April 2026
- change zodbpack iamge [Dobricean Ioan Dorian - [`0399bb3c`](https://github.com/eea/helm-charts/commit/0399bb3c5c8b608aae24787f630d2db93ed7e210)]

### Version 0.2.25 - 09 April 2026
- make zodbpack inherit the main backend image by default

### Version 0.2.24 - 09 April 2026
- relax plone [Dobricean Ioan Dorian - [`5b0ee8b9`](https://github.com/eea/helm-charts/commit/5b0ee8b92c5d151cd7ce8effb764007a9dff07b2)]

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
