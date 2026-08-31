# CCA Backend

Helm chart for the Climate-ADAPT backend stack.

The chart follows the conventions already used in this repository for Plone
backends and adds the CCA-specific supporting services from the Rancher stack:
`plone-translate`, `redis`, `async`, `converter`, `zodbpack`
and the broken-links cron job.

Sensitive values are intentionally left empty in `values.yaml`.
## Releases

### Version 0.9.18 - 31 August 2026
- v11.0.56-plone6.1 [GhitaB - [`efb6878a`](https://github.com/eea/helm-charts/commit/efb6878af1d6a9d3d21bd0fe9b8e910af39bbfce)]

### Version 0.9.17 - 28 August 2026
- v11.0.55-plone6.1 [GhitaB - [`6b348e7b`](https://github.com/eea/helm-charts/commit/6b348e7b9b7d83d89781e11ccb61e99b5eb72af2)]

### Version 0.9.16 - 27 August 2026
- v11.0.54-plone6.1 [GhitaB - [`6da3156c`](https://github.com/eea/helm-charts/commit/6da3156ccadf8d7d8240027c1d8ed201ffb95ab0)]

### Version 0.9.15 - 27 August 2026
- v11.0.53-plone6.1 [GhitaB - [`3fdee296`](https://github.com/eea/helm-charts/commit/3fdee296f8776f16bdb53a574fd3a27725432163)]

### Version 0.9.14 - 24 August 2026
- v11.0.52-plone6.1 [GhitaB - [`1e8c1273`](https://github.com/eea/helm-charts/commit/1e8c12732d15f0bc01259a202e2c928489480c36)]

### Version 0.9.13 - 24 August 2026
- v11.0.51-plone6.1 [GhitaB - [`5527ac00`](https://github.com/eea/helm-charts/commit/5527ac007d19687e3cca4bf06d370bb6036154d3)]

### Version 0.9.11 - 20 August 2026
- v11.0.49-plone6.1 [GhitaB - [`7dc5212b`](https://github.com/eea/helm-charts/commit/7dc5212b7547585d5c06c23f5a196acaedffdf15)]

### Version 0.9.8 - 19 August 2026
- v11.0.46-plone6.1 [GhitaB - [`60088158`](https://github.com/eea/helm-charts/commit/6008815840ca0f676cacd9c7bc0637ca514887cc)]

### Version 0.9.6 - 18 August 2026
- v11.0.44-plone6.1 [GhitaB - [`691708f1`](https://github.com/eea/helm-charts/commit/691708f1e38996ad7c1a4ada07c3a2d6777de6d2)]

### Version 0.9.5 - 18 August 2026
- v11.0.43-plone6.1 [GhitaB - [`17b4753a`](https://github.com/eea/helm-charts/commit/17b4753a431e9ab695acc39e22bbd538416f8f14)]

### Version 0.9.4 - 17 August 2026
- v11.0.42-plone6.1 [GhitaB - [`11ff16ac`](https://github.com/eea/helm-charts/commit/11ff16ac322d518058d244e403b6b6131ac230f9)]

### Version 0.9.0 - 10 August 2026
- Automated release of [eeacms/eea.docker.plone-climateadapt:v11.0.34-plone6.1](https://github.com/eea/eea.docker.plone-climateadapt/releases) [EEA Jenkins - [`193d46d0`](https://github.com/eea/helm-charts/commit/193d46d0a4ebc10a9e9b4361154a1e6dbbb9324c)]

### Version 0.8.0 - 06 August 2026
- Automated release of [eeacms/eea.docker.plone-climateadapt:v11.0.33-plone6.1](https://github.com/eea/eea.docker.plone-climateadapt/releases) [EEA Jenkins - [`a116406c`](https://github.com/eea/helm-charts/commit/a116406c264633ca78a680a26110fd5504ff7333)]

### Version 0.7.0 - 04 August 2026
- Automated release of [eeacms/eea.docker.plone-climateadapt:v11.0.32-plone6.1](https://github.com/eea/eea.docker.plone-climateadapt/releases) [EEA Jenkins - [`c9dc5aaa`](https://github.com/eea/helm-charts/commit/c9dc5aaa45ea2c5725126cd8852756de2b5e0e9a)]

### Version 0.6.15 - 28 July 2026
- in cca-backend: 0.6.15 [GhitaB - [`6b1cd375`](https://github.com/eea/helm-charts/commit/6b1cd375d0e71a0a4862a7707e5ef82b3c5d76ae)]

### Version 0.6.12 - 22 iulie 2026
- Upgrade to v11.0.27 backend [Tiberiu Ichim - [`1cea07df`](https://github.com/eea/helm-charts/commit/1cea07dffe273b526e5f80da1ca92561df675fa2)]

### Version 0.6.8 - 20 iulie 2026
- Upgrade to v11.0.24-plone6.1 [Tiberiu Ichim - [`bd720643`](https://github.com/eea/helm-charts/commit/bd720643ab421cd280d8c2c9a41fc22d057eb755)]

### Version 0.6.4 - 19 June 2026
- appVersion to v11.0.17-plone6.1 [Tiberiu Ichim - [`2ccc2748`](https://github.com/eea/helm-charts/commit/2ccc27488dcc7562198e4cd02e878aa852b38721)]

### Version 0.6.3 - 16 June 2026
- v11.0.16-plone6.1 [Tiberiu Ichim - [`fad3b608`](https://github.com/eea/helm-charts/commit/fad3b6083a8505338feb8eeb5131dc32ffc3db74)]

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
