# EEA Website backend - Plone 6

This chart deployes the EEA Website Plone 6 backend app 

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| debug.enabled | bool | false | Activate the Plone debug instance |

## Releases

### Version 1.22.0 - 24 October 2025
- Automated release of [eeacms/eea-website-backend:6.0.15-47](https://github.com/eea/eea-website-backend/releases) [EEA Jenkins - [`2c395787`](https://github.com/eea/helm-charts/commit/2c3957875e35a7f3e540506d9bf6851dc44151ff)]

### Version 1.21.0 - 22 October 2025
- Automated release of [eeacms/eea-website-backend:6.0.15-46](https://github.com/eea/eea-website-backend/releases) [EEA Jenkins - [`15549b7d`](https://github.com/eea/helm-charts/commit/15549b7d88c08035f8ca22743860995a5135982d)]

### Version 1.20.0 - 08 October 2025
- Automated release of [eeacms/eea-website-backend:6.0.15-45](https://github.com/eea/eea-website-backend/releases) [EEA Jenkins - [`90d5696f`](https://github.com/eea/helm-charts/commit/90d5696f763fdd5a6141489107082f094763f263)]

### Version 1.19.2 - 26 September 2025
- Fix nginx conf when debug is disabled [Alin Voinea - [`6866a3eb`](https://github.com/eea/helm-charts/commit/6866a3eb5a2779e9eeaecd28446fb8f47a1f4707)]

### Version 1.19.1 - 23 September 2025
- Add possibility to deploy debug_backend [Alin Voinea - [`ecd63a0d`](https://github.com/eea/helm-charts/commit/ecd63a0d202a5487fb87031c7eec8bed5de988d6)]

### Version 1.19.0 - 23 September 2025
- Automated release of [eeacms/eea-website-backend:6.0.15-44](https://github.com/eea/eea-website-backend/releases) [EEA Jenkins - [`9cd79028`](https://github.com/eea/helm-charts/commit/9cd79028ae1b41315d6916106580bde69621b579)]

### Version 1.18.1 - 10 September 2025
- fix: entrasync and zodbpack cronjobs - Refs [#291988](https://taskman.eionet.europa.eu/issues/291988) [Alin Voinea - [`19a3c028`](https://github.com/eea/helm-charts/commit/19a3c0284f34e1319915d8cfcce4df879cbcb076)]

### Version 1.18.0 - 28 August 2025
- Automated release of [eeacms/eea-website-backend:6.0.15-43](https://github.com/eea/eea-website-backend/releases) [EEA Jenkins - [`468ca1d7`](https://github.com/eea/helm-charts/commit/468ca1d786c79c3dad201468e8de4584d08468b1)]

### Version 1.17.0 - 27 August 2025
- Automated release of [eeacms/eea-website-backend:6.0.15-42](https://github.com/eea/eea-website-backend/releases) [EEA Jenkins - [`e1083e6f`](https://github.com/eea/helm-charts/commit/e1083e6fb876292f240a5f55d74eb07027d085fb)]

### Version 1.16.0 - 27 August 2025
- Automated release of [eeacms/eea-website-backend:6.0.15-41](https://github.com/eea/eea-website-backend/releases) [EEA Jenkins - [`94908adb`](https://github.com/eea/helm-charts/commit/94908adb39c17c14388fe3bd775357c81fd6d920)]

### Version 1.15.2 - 27 August 2025
- Fix deployments/scale.apps plone not found [Alin Voinea - [`61e5fc40`](https://github.com/eea/helm-charts/commit/61e5fc4074f3729290260a7ac522d44946ee9b02)]

### Version 1.15.1 - 25 August 2025
- Release of dependent chart postfix:3.1.0 [EEA Jenkins - [`6b299527`](https://github.com/eea/helm-charts/commit/6b299527cae96cccfc8170c80a78b37f47854d92)]

### Version 1.15.0 - 20 August 2025
- Automated release of [eeacms/eea-website-backend:6.0.15-40](https://github.com/eea/eea-website-backend/releases) [EEA Jenkins - [`e360f568`](https://github.com/eea/helm-charts/commit/e360f568926a896af88714cc2049107cca6f7de0)]

### Version 1.14.0 - 20 August 2025
- Automated release of [eeacms/eea-website-backend:6.0.15-39](https://github.com/eea/eea-website-backend/releases) [EEA Jenkins - [`8f23ed88`](https://github.com/eea/helm-charts/commit/8f23ed8862bb45c9efe036006e937e5fc2149564)]

### Version 1.13.0 - 20 August 2025
- Automated release of [eeacms/eea-website-backend:6.0.15-38](https://github.com/eea/eea-website-backend/releases) [EEA Jenkins - [`a3d08314`](https://github.com/eea/helm-charts/commit/a3d08314cade2d3b2a83e1b3874c13c4a34ee96b)]

### Version 1.12.6 - 14 August 2025
- Add ingress.enabled variable [valentinab25 - [`4121ae87`](https://github.com/eea/helm-charts/commit/4121ae8734e8c3aaa1c29b5ff2af17cb7f27313e)]

### Version 1.12.5 - 13 August 2025
- add log to stdout for nginx [Silviu - [`dd4f5421`](https://github.com/eea/helm-charts/commit/dd4f542153adb1265fcce49e0936e96e25214a91)]

### Version 1.12.4 - 13 August 2025
- Use ingress class name in configuration [valentinab25 - [`80728629`](https://github.com/eea/helm-charts/commit/807286291165f56ee9a87ca01e2cf07cb45bc937)]

### Version 1.12.3 - 13 August 2025
- Use selector labels [valentinab25 - [`b30ea52d`](https://github.com/eea/helm-charts/commit/b30ea52d07799ba75a97700fa682a2d67ee7700b)]

### Version 1.12.2 - 13 August 2025
- Fix postgres service if external [valentinab25 - [`06e1a86a`](https://github.com/eea/helm-charts/commit/06e1a86a3e418b268dbac27b83d2ea9a14ad4ee7)]

### Version 1.12.1 - 13 August 2025
- Add ingressClassName variable [valentinab25 - [`e9e1b6e6`](https://github.com/eea/helm-charts/commit/e9e1b6e6a47b4bd4c0a9591276ec492b7a40ef7f)]

### Version 1.12.0 - 11 August 2025
- Automated release of [eeacms/eea-website-backend:6.0.15-37](https://github.com/eea/eea-website-backend/releases) [EEA Jenkins - [`2f999e42`](https://github.com/eea/helm-charts/commit/2f999e42a6f9ca9808265a30964834dbfe548fd4)]

### Version 1.11.1 - 07 August 2025
- Add db host as variable [Silviu - [`b4eef131`](https://github.com/eea/helm-charts/commit/b4eef131f7d0663a3c01ec44545000eb7b7dddf5)]

### Version 1.11.0 - 05 August 2025
- Automated release of [eeacms/eea-website-backend:6.0.15-36](https://github.com/eea/eea-website-backend/releases) [EEA Jenkins - [`cda877e2`](https://github.com/eea/helm-charts/commit/cda877e2a32b149f0757b6f040b0e61c12c32cf2)]

### Version 1.10.0 - 05 August 2025
- Automated release of [eeacms/eea-website-backend:6.0.15-35](https://github.com/eea/eea-website-backend/releases) [EEA Jenkins - [`3e62d172`](https://github.com/eea/helm-charts/commit/3e62d17259033e285ccb27d02ea7e5ddb5edcc61)]

### Version 1.9.0 - 02 August 2025
- Automated release of [eeacms/eea-website-backend:6.0.15-34](https://github.com/eea/eea-website-backend/releases) [EEA Jenkins - [`952c2da1`](https://github.com/eea/helm-charts/commit/952c2da1ee2aec205757f96fa6764071ee53940e)]

### Version 1.8.1 - 01 August 2025
- Automated release of [eeacms/plone-varnish:7.7-1.1](https://github.com/eea/plone-varnish/releases) [EEA Jenkins - [`a61144cc`](https://github.com/eea/helm-charts/commit/a61144ccc62d4c02bd4352957f63807a383b184a)]

### Version 1.8.0 - 01 August 2025
- Automated release of [eeacms/eea-website-backend:internal](https://github.com/eea/eea-website-backend/releases) [EEA Jenkins - [`faae0c88`](https://github.com/eea/helm-charts/commit/faae0c8820b3750fe433eda2be1a35183fd7f23a)]

### Version 1.7.0 - 28 July 2025
- Automated release of [eeacms/eea-website-backend:6.0.15-32](https://github.com/eea/eea-website-backend/releases) [EEA Jenkins - [`205b509a`](https://github.com/eea/helm-charts/commit/205b509a0c6d3bf8be6c3f9c5d564bc2c05ab665)]

### Version 1.6.0 - 25 July 2025
- Automated release of [eeacms/eea-website-backend:6.0.15-31](https://github.com/eea/eea-website-backend/releases) [EEA Jenkins - [`bb22277e`](https://github.com/eea/helm-charts/commit/bb22277e83438ccc73234464988ba3926749da97)]

### Version 1.5.0 - 23 July 2025
- Automated release of [eeacms/eea-website-backend:6.0.15-30](https://github.com/eea/eea-website-backend/releases) [EEA Jenkins - [`196c8e04`](https://github.com/eea/helm-charts/commit/196c8e04a98fc143cdb2ffddf5a75d0bf6072af7)]

### Version 1.4.0 - 16 July 2025
- Automated release of [eeacms/eea-website-backend:6.0.15-29](https://github.com/eea/eea-website-backend/releases) [EEA Jenkins - [`2cd405a4`](https://github.com/eea/helm-charts/commit/2cd405a44f15e396ef71d9d87f5bf20ed173a003)]

### Version 1.3.0 - 20 June 2025
- Automated release of [eeacms/eea-website-backend:6.0.15-27](https://github.com/eea/eea-website-backend/releases) [EEA Jenkins - [`60f983e8`](https://github.com/eea/helm-charts/commit/60f983e8d4e1ebf10c5324a7165bc886211eee37)]

### Version 1.2.0 - 12 June 2025
- Automated release of [eeacms/eea-website-backend:6.0.15-26](https://github.com/eea/eea-website-backend/releases) [EEA Jenkins - [`188019a`](https://github.com/eea/helm-charts/commit/188019a7fc47ff0820b57167461df246b41a6203)]

### Version 1.1.0 - 11 June 2025
- Automated release of [eeacms/eea-website-backend:6.0.15-25](https://github.com/eea/eea-website-backend/releases) [EEA Jenkins - [`c6142dd`](https://github.com/eea/helm-charts/commit/c6142ddd56ad4ad7f387b06c350bd2f1013266e8)]

### Version 1.0.6 - 11 June 2025
- update nginx defaults [Silviu - [`b629266`](https://github.com/eea/helm-charts/commit/b6292663d8d4ca59f0b13895478c68ce4c2691f9)]

### Version 1.0.5 - 11 June 2025
- update rewrite rules [Silviu - [`f848977`](https://github.com/eea/helm-charts/commit/f8489772ffbbe2db4d1ba20115f3604c346643da)]

### Version 1.0.4 - 11 June 2025
- ingress update [Silviu - [`17525fb`](https://github.com/eea/helm-charts/commit/17525fbd75a12abf92a3bc59efe8521d8551b738)]

### Version 1.0.4 - 11 June 2025
- ingress update [Silviu - [`5570716`](https://github.com/eea/helm-charts/commit/557071648484c9838ce34c5e64ae5769065f438f)]

### Version 1.0.4 - 11 June 2025
- ingress update [Silviu - [`5b15ba6`](https://github.com/eea/helm-charts/commit/5b15ba6f9e6bd46e415ec89f022020b55c1048a5)]

### Version 1.0.4 - 11 June 2025
- dasd [Silviu - [`26be0ec`](https://github.com/eea/helm-charts/commit/26be0ec8030eec943eb6cfd7a1182b455ea0fbda)]

### Version 1.0.4 - 11 June 2025
- update ingress [Silviu - [`d5b0d59`](https://github.com/eea/helm-charts/commit/d5b0d59e4108187b9dc68fcb8752d2e6dc611a2e)]
### Version 1.0.4 - 11 June 2025
- patch nginx deployment [Silviu - [`2b095e9`](https://github.com/eea/helm-charts/commit/2b095e9dead5eaa28b4b0807ab8993246cb65730)]

### Version 1.0.2 - 11 June 2025
- update nginx service name [Silviu - [`060146f`](https://github.com/eea/helm-charts/commit/060146fd845b701a5781acef1842bd94df58f59f)]

### Version 1.0.1 - 11 June 2025
- add nginx deployment [Silviu - [`65dd5e3`](https://github.com/eea/helm-charts/commit/65dd5e3bea73e4b993ce41979bcd0995efefbff6)]

### Version 1.0.0
- Initial release. Version matching Rancher 1 catalog version.
