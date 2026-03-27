# CCA Frontend

Helm chart for the Climate-ADAPT frontend stack.

The chart follows the Volto/Varnish pattern already present in this repository
and adds the Apache routing layer used by the existing Rancher stack. Secrets
and tokens are intentionally left empty in `values.yaml`.
## Releases

### Version 0.4.13 - 27 March 2026
- add nginx in front [Dobricean Ioan Dorian - [`c97fca08`](https://github.com/eea/helm-charts/commit/c97fca08d500b2bf6782093fcba50227d5dff72e)]

### Version 0.4.8 - 27 March 2026
- fi ingress [Dobricean Ioan Dorian - [`24cad991`](https://github.com/eea/helm-charts/commit/24cad991e9a9765ebcc2b46c3275b79575b75022)]

### Version 0.4.6 - 27 March 2026
- fix backend issue [Dobricean Ioan Dorian - [`97379b14`](https://github.com/eea/helm-charts/commit/97379b149083429e93cedb0f3449adee8bcf6314)]

### Version 0.4.4 - 27 March 2026
- remove apache [Dobricean Ioan Dorian - [`e3b599bb`](https://github.com/eea/helm-charts/commit/e3b599bb2f46146f84e073e75738783ebdf0ca02)]

### Version 0.4.2 - 26 March 2026
- fix varnish deployment [Dobricean Ioan Dorian - [`58eaf33d`](https://github.com/eea/helm-charts/commit/58eaf33dc3155e1bf551d6445319f15b08004384)]

### Version 0.4.0 - 20 March 2026
- Automated release of [eeacms/cca-frontend:3.39.0](https://github.com/eea/cca-frontend/releases) [EEA Jenkins - [`1754e657`](https://github.com/eea/helm-charts/commit/1754e657753cff7535e01434fc84d0ea44bdbcfc)]

### Version 0.3.0 - 19 March 2026
- Automated release of [eeacms/cca-frontend:3.38.0](https://github.com/eea/cca-frontend/releases) [EEA Jenkins - [`7a746be9`](https://github.com/eea/helm-charts/commit/7a746be9d2abc1c516a7b03230628d9d9a778e9a)]

### Version 0.2.0 - 17 March 2026
- Automated release of [eeacms/cca-frontend:3.28.1-alpha.15](https://github.com/eea/cca-frontend/releases) [EEA Jenkins - [`d2eab61f`](https://github.com/eea/helm-charts/commit/d2eab61f74fba8f15e58f1ea4ce863f702a7130c)]

### Version 0.1.1 - 13 March 2026
- add questions [Dobricean Ioan Dorian - [`43f14405`](https://github.com/eea/helm-charts/commit/43f144055b47dddc298a8b8a5d0a15eda0dbce22)]

