# CCA Frontend

Helm chart for the Climate-ADAPT frontend stack.

The chart follows the Volto/Varnish pattern already present in this repository
and adds the Apache routing layer used by the existing Rancher stack. Secrets
and tokens are intentionally left empty in `values.yaml`.
