# Changelog

## [0.2.26](https://github.com/onyx-dot-app/vespa-helm-charts/compare/vespa-0.2.24...vespa-0.3.0) (2026-01-16)

### Improvements

* Add JAVA OPTS for env for startup 


## [0.2.24](https://github.com/onyx-dot-app/vespa-helm-charts/compare/vespa-0.2.23...vespa-0.2.24) (2025-08-06)

### Bug Fixes

* Add missing pod scheduling fields to StatefulSet template ([#PR_NUMBER](https://github.com/onyx-dot-app/vespa-helm-charts/pull/PR_NUMBER))
  * Add `nodeSelector` support for node selection
  * Add `affinity` support for advanced scheduling rules  
  * Add `tolerations` support for taint toleration
  * This enables proper pod scheduling configuration through Helm values, which is essential for production deployments with dedicated nodes and taints

## [0.2.21](https://github.com/onyx-dot-app/vespa-helm-charts/compare/vespa-0.2.18...vespa-v0.2.16) (2024-12-10)

* Update default memory to 4GB and storage to 8GB per Vespa recommended settings.
  * See https://docs.vespa.ai/en/vespa-quick-start.html

## [0.2.18](https://github.com/onyx-dot-app/vespa-helm-charts/compare/vespa-0.2.18...vespa-v0.2.16) (2024-12-10)

* Rename danswer-ai to onyx-dot-app

## [0.2.16]

* forked to danswer-ai, brought up to date to work with Danswer and helm chart testing

## [0.2.3](https://github.com/unoplat/vespa-helm-charts/compare/vespa-0.2.2...vespa-v0.2.3) (2024-05-07)


### Bug Fixes

* lower cpu and memory footprint to make it possible to run easily on local cmpute ([d36df44](https://github.com/unoplat/vespa-helm-charts/commit/d36df44ad0c6a1a149be13777a49c6a88ce78254))

## [0.2.2](https://github.com/unoplat/vespa-helm-charts/compare/vespa-0.2.1...vespa-v0.2.2) (2024-03-27)


### Bug Fixes

* values and labels ([edc2ca9](https://github.com/unoplat/vespa-helm-charts/commit/edc2ca99681c1444d3107446101e40ea42752102))

## [0.2.1](https://github.com/unoplat/vespa-helm-charts/compare/vespa-v0.2.0...vespa-v0.2.1) (2024-03-19)


### Bug Fixes

* testing helm package release ([df9fa97](https://github.com/unoplat/vespa-helm-charts/commit/df9fa9744c79440756e550fea5fbe03d7915d7cf))

## [0.2.0](https://github.com/unoplat/vespa-helm-charts/compare/vespa-0.1.0...vespa-v0.2.0) (2024-03-14)


### Features

* initial helm chart release ([8bc20bc](https://github.com/unoplat/vespa-helm-charts/commit/8bc20bcc7afd36fdd641fd1d00d645604927e5ac))

## [0.1.0](https://github.com/unoplat/vespa-helm-charts/compare/vespa-v0.0.1...vespa-v0.1.0) (2024-03-14)


### Features

* initial chart commit ([ab4b63a](https://github.com/unoplat/vespa-helm-charts/commit/ab4b63ad37c3d74ffb2be8e2ffe6a77db8ac7c7b))
* initial commit ([a3d575f](https://github.com/unoplat/vespa-helm-charts/commit/a3d575fb459a1d5e0b07ede150d7d996da119c72))


### Bug Fixes

* bug squashed ([653c66c](https://github.com/unoplat/vespa-helm-charts/commit/653c66c407829550e20315175622800baf2d5af8))
* dummy change to resource to test release ([fa3f7bc](https://github.com/unoplat/vespa-helm-charts/commit/fa3f7bc6effc178d088cc8c5c879be6027310d07))
* dummy commit to test release ([e685165](https://github.com/unoplat/vespa-helm-charts/commit/e6851659609aa07bc42f4ce707cb17ad45b41b62))
* dummy fix to test release ([00e11f6](https://github.com/unoplat/vespa-helm-charts/commit/00e11f627aa14bf0361627c470da28fad5a75ac5))
