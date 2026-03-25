# CCA Backend

Helm chart for the Climate-ADAPT backend stack.

The chart follows the conventions already used in this repository for Plone
backends and adds the CCA-specific supporting services from the Rancher stack:
`plone-admin`, `plone-translate`, `redis`, `async`,
`converter`, `zodbpack` and the broken-links cron job.

Sensitive values are intentionally left empty in `values.yaml`.
## Releases

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
