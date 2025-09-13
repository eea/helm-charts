# EEA Main Website frontend - Plone 6

This chart deploys the EEA Main Website frontend app


## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| links.backend | string | NAME.NAMESPACE | Service name for varnish for backend instance, followed by the namespace. |

## Releases

### Version 1.25.0 - 13 September 2025
- Automated release of [eeacms/eea-website-frontend:2.44.0](https://github.com/eea/eea-website-frontend/releases) [EEA Jenkins - [`f4587054`](https://github.com/eea/helm-charts/commit/f45870542cc14ab91100ce323e98218b6a5bdb18)]

### Version 1.24.0 - 10 September 2025
- Automated release of [eeacms/eea-website-frontend:2.43.1-beta.1](https://github.com/eea/eea-website-frontend/releases) [EEA Jenkins - [`b2573c65`](https://github.com/eea/helm-charts/commit/b2573c65c683eca49861db7b85d2896b93c93a18)]

### Version 1.23.0 - 10 September 2025
- Automated release of [eeacms/eea-website-frontend:2.43.0](https://github.com/eea/eea-website-frontend/releases) [EEA Jenkins - [`f9624822`](https://github.com/eea/helm-charts/commit/f9624822f6b00fe65dd60c9473fdf1de6bcfabcd)]

### Version 1.22.0 - 09 September 2025
- Automated release of [eeacms/eea-website-frontend:2.42.0](https://github.com/eea/eea-website-frontend/releases) [EEA Jenkins - [`451a31a5`](https://github.com/eea/helm-charts/commit/451a31a55a2077422a367ad2df6ceb3c644fca4f)]

### Version 1.21.1 - 28 August 2025
- Add producton ingress settings [Alin Voinea - [`1db28c25`](https://github.com/eea/helm-charts/commit/1db28c25cd9a0560978579bd9db6d7ca890688bc)]

### Version 1.21.0 - 27 August 2025
- Automated release of [eeacms/eea-website-frontend:2.41.0](https://github.com/eea/eea-website-frontend/releases) [EEA Jenkins - [`68b757c8`](https://github.com/eea/helm-charts/commit/68b757c8d3221b4c7aa38f65af0b95345a088e5c)]

### Version 1.20.1 - 27 August 2025
- Fix deployments/scale.apps volto not found [Alin Voinea - [`c1f6ee3e`](https://github.com/eea/helm-charts/commit/c1f6ee3e5cb6ee059e077898dfa4c612933226e3)]

### Version 1.20.0 - 21 August 2025
- Automated release of [eeacms/eea-website-frontend:2.40.0](https://github.com/eea/eea-website-frontend/releases) [EEA Jenkins - [`c4444983`](https://github.com/eea/helm-charts/commit/c444498322185346c65176eac7239f52c264be7f)]

### Version 1.19.0 - 21 August 2025
- Automated release of [eeacms/eea-website-frontend:2.39.0](https://github.com/eea/eea-website-frontend/releases) [EEA Jenkins - [`da858b78`](https://github.com/eea/helm-charts/commit/da858b78e66dcab07f39a00ad6f008b065768e6d)]

### Version 1.18.0 - 20 August 2025
- Automated release of [eeacms/eea-website-frontend:2.38.0](https://github.com/eea/eea-website-frontend/releases) [EEA Jenkins - [`16f22c19`](https://github.com/eea/helm-charts/commit/16f22c19803c5fd229be1bfda5eb8cb5863d85f8)]

### Version 1.17.9 - 20 August 2025
- add ingress pathType as a value [Silviu - [`df4f0fc8`](https://github.com/eea/helm-charts/commit/df4f0fc84940386611a1a85c113133045f27019f)]

### Version 1.17.8 - 20 August 2025
- Remove CSP as its not needed [valentinab25 - [`cad2c579`](https://github.com/eea/helm-charts/commit/cad2c5790cb10ae87b7eb2b4f766ba2fcb627eea)]

### Version 1.17.7 - 19 August 2025
- update default values [Silviu - [`8c4d15b2`](https://github.com/eea/helm-charts/commit/8c4d15b2319f0e5dbc429ad8326ba6740695055e)]

### Version 1.17.6 - 14 August 2025
- add storage accessmode var [valentinab25 - [`56767b15`](https://github.com/eea/helm-charts/commit/56767b15aa73846f538c5faa9ebbb3680811be45)]

### Version 1.17.5 - 14 August 2025
- Add storageclass, allow ingress backend redirect [valentinab25 - [`4dc2a2ea`](https://github.com/eea/helm-charts/commit/4dc2a2eaefba690b9c12719d37d0a527df5abf10)]

### Version 1.17.4 - 13 August 2025
- add default nginx logs to stdout [Silviu - [`14660f60`](https://github.com/eea/helm-charts/commit/14660f60499ec6d054d59a96cb86796447e0f16b)]

### Version 1.17.3 - 13 August 2025
- fix selector labels nginx [valentinab25 - [`aefd42e0`](https://github.com/eea/helm-charts/commit/aefd42e0c9bd6fb1ecc19f0310c92e0f6e97279f)]

### Version 1.17.2 - 13 August 2025
- Use ingress class in configuration [valentinab25 - [`43b18ff1`](https://github.com/eea/helm-charts/commit/43b18ff13263d7298bc0e44e46cec3a6d22e3288)]

### Version 1.17.1 - 13 August 2025
- Add ingress classname [valentinab25 - [`11e7f584`](https://github.com/eea/helm-charts/commit/11e7f584796ea48eb2640fa15e931cdc5edaed7a)]

### Version 1.17.0 - 04 August 2025
- Automated release of [eeacms/eea-website-frontend:2.36.1-beta.0](https://github.com/eea/eea-website-frontend/releases) [EEA Jenkins - [`08f3e227`](https://github.com/eea/helm-charts/commit/08f3e22702e0d56ea293976b6cf79f463cf9bd6a)]

### Version 1.16.1 - 01 August 2025
- Automated release of [eeacms/plone-varnish:7.7-1.1](https://github.com/eea/plone-varnish/releases) [EEA Jenkins - [`9899531b`](https://github.com/eea/helm-charts/commit/9899531b493acc9fd072e1cf9e51f28edf7d5f47)]

### Version 1.16.0 - 30 July 2025
- Automated release of [eeacms/eea-website-frontend:2.36.0](https://github.com/eea/eea-website-frontend/releases) [EEA Jenkins - [`9ad2a939`](https://github.com/eea/helm-charts/commit/9ad2a939672d71c0653e90d9b8c97720f7c563eb)]

### Version 1.15.0 - 30 July 2025
- Automated release of [eeacms/eea-website-frontend:2.35.1-beta.4](https://github.com/eea/eea-website-frontend/releases) [EEA Jenkins - [`1a2c0f25`](https://github.com/eea/helm-charts/commit/1a2c0f256e1878e6a42c9d77bc6699302028cc1e)]

### Version 1.14.0 - 30 July 2025
- Automated release of [eeacms/eea-website-frontend:2.35.1-beta.3](https://github.com/eea/eea-website-frontend/releases) [EEA Jenkins - [`89c5f320`](https://github.com/eea/helm-charts/commit/89c5f320cd0a44119276310db8a2dc82b555acae)]

### Version 1.13.0 - 28 July 2025
- Automated release of [eeacms/eea-website-frontend:2.35.1-beta.2](https://github.com/eea/eea-website-frontend/releases) [EEA Jenkins - [`aece0e10`](https://github.com/eea/helm-charts/commit/aece0e1018a9505258d506b5ebcb25b4e7e33990)]

### Version 1.12.0 - 25 July 2025
- Automated release of [eeacms/eea-website-frontend:2.35.1-beta.1](https://github.com/eea/eea-website-frontend/releases) [EEA Jenkins - [`1ec7d7ff`](https://github.com/eea/helm-charts/commit/1ec7d7ffcf0b7decd432158b5272f3834a1643ac)]

### Version 1.11.0 - 25 July 2025
- Automated release of [eeacms/eea-website-frontend:2.35.1-beta.0](https://github.com/eea/eea-website-frontend/releases) [EEA Jenkins - [`f3d722f6`](https://github.com/eea/helm-charts/commit/f3d722f697a4913779277773ada71dc29ac25cc2)]

### Version 1.10.0 - 24 July 2025
- Automated release of [eeacms/eea-website-frontend:2.35.0](https://github.com/eea/eea-website-frontend/releases) [EEA Jenkins - [`86f938b7`](https://github.com/eea/helm-charts/commit/86f938b78ad2b77011a4afaf2796b72691c613df)]

### Version 1.9.0 - 23 July 2025
- Automated release of [eeacms/eea-website-frontend:2.34.2-beta.1](https://github.com/eea/eea-website-frontend/releases) [EEA Jenkins - [`c68d9563`](https://github.com/eea/helm-charts/commit/c68d9563c07ab7a791cec071528b36a9a5198071)]

### Version 1.8.0 - 23 July 2025
- Automated release of [eeacms/eea-website-frontend:2.34.2-beta.0](https://github.com/eea/eea-website-frontend/releases) [EEA Jenkins - [`77f38af2`](https://github.com/eea/helm-charts/commit/77f38af26f07238f14f9a360dcb8eede9ec41785)]

### Version 1.7.0 - 18 July 2025
- Automated release of [eeacms/eea-website-frontend:2.34.1](https://github.com/eea/eea-website-frontend/releases) [EEA Jenkins - [`4a6335ad`](https://github.com/eea/helm-charts/commit/4a6335ad4ccf41dda3693f2c0199239001650423)]

### Version 1.6.0 - 15 July 2025
- Automated release of [eeacms/eea-website-frontend:2.34.0](https://github.com/eea/eea-website-frontend/releases) [EEA Jenkins - [`d5c19b7c`](https://github.com/eea/helm-charts/commit/d5c19b7c832563feea093fc746100da07d0cbd50)]

### Version 1.5.0 - 07 July 2025
- Automated release of [eeacms/eea-website-frontend:2.33.0-beta.2](https://github.com/eea/eea-website-frontend/releases) [EEA Jenkins - [`aa414136`](https://github.com/eea/helm-charts/commit/aa414136f07c99d62e4d4e6a45317b2c6b50e2e9)]

### Version 1.4.0 - 07 July 2025
- Automated release of [eeacms/eea-website-frontend:2.33.0-beta.1](https://github.com/eea/eea-website-frontend/releases) [EEA Jenkins - [`b9181a0c`](https://github.com/eea/helm-charts/commit/b9181a0ce9871725e1f5f6ca0290b34537bdfa6f)]

### Version 1.3.0 - 03 July 2025
- Automated release of [eeacms/eea-website-frontend:2.32.1](https://github.com/eea/eea-website-frontend/releases) [EEA Jenkins - [`8db15509`](https://github.com/eea/helm-charts/commit/8db155096518846ffb98818e02a83a41107f2304)]

### Version 1.2.0 - 02 July 2025
- Automated release of [eeacms/eea-website-frontend:2.32.0](https://github.com/eea/eea-website-frontend/releases) [EEA Jenkins - [`e3db4560`](https://github.com/eea/helm-charts/commit/e3db456001a7e9ecd70a9365888692b75c5c3c82)]

### Version 1.1.5 - 11 June 2025
- update nginx defaults [Silviu - [`5969310`](https://github.com/eea/helm-charts/commit/59693107b1af30d0ac0967d552689ef55b7d23f0)]

### Version 1.1.4 - 11 June 2025
- update default values [Silviu - [`e169f75`](https://github.com/eea/helm-charts/commit/e169f75ae27b6ccfdc6b3901668b142345d8eacd)]

### Version 1.1.3 - 11 June 2025
- update question to multiline [Silviu - [`44913ba`](https://github.com/eea/helm-charts/commit/44913ba9549eff0ebb16a31136bd9cee3349fc26)]

### Version 1.1.2 - 11 June 2025
- update nginx default config [Silviu - [`b022ea4`](https://github.com/eea/helm-charts/commit/b022ea4bc421473b239c034ecadb536213ec39e6)]

### Version 1.1.1 - 10 June 2025
- add nginx [Silviu - [`b0a9a78`](https://github.com/eea/helm-charts/commit/b0a9a78c2d850925107676b207666218785c55a2)]

### Version 1.1.0 - 06 June 2025
- Automated release of [eeacms/eea-website-frontend:2.31.0](https://github.com/eea/eea-website-frontend/releases) [EEA Jenkins - [`da9ee48`](https://github.com/eea/helm-charts/commit/da9ee4821aa9e15a8fc36b7380aeb524890e7c7c)]

### Version 1.0.0
- Initial release. Version matching Rancher 1 catalog version.
