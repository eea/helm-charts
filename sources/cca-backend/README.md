# CCA Backend

Helm chart for the Climate-ADAPT backend stack.

The chart follows the conventions already used in this repository for Plone
backends and adds the CCA-specific supporting services from the Rancher stack:
`plone-admin`, `plone-translate`, `haproxy`, `redis`, `memcached`, `async`,
`converter`, `zodbpack` and the broken-links cron job.

Sensitive values are intentionally left empty in `values.yaml`.
