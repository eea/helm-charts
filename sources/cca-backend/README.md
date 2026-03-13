# CCA Backend

Helm chart for the Climate-ADAPT backend stack.

The chart follows the conventions already used in this repository for Plone
backends and adds the CCA-specific supporting services from the Rancher stack:
`plone-admin`, `plone-translate`, `redis`, `async`,
`converter`, `zodbpack` and the broken-links cron job.

Sensitive values are intentionally left empty in `values.yaml`.
## Releases

### Version 0.2.4 - 13 March 2026
- align to deafult plone ingress [Dobricean Ioan Dorian - [`96ec0111`](https://github.com/eea/helm-charts/commit/96ec0111414ef54c7630cec54a39a71b6e347fc3)]

### Version 0.2.2 - 13 March 2026
- change questions [Dobricean Ioan Dorian - [`d02e405a`](https://github.com/eea/helm-charts/commit/d02e405af2aebb1f6dee9cae7e2f6e172615db11)]
