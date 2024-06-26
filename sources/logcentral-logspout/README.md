# EEA - Logspout

**Kubernetes uses containerd and has removed support for Docker control socket from version 1.24 onwards.**

Glider Labs Logspout for docker logs to logcentral.

Logspout Agents: To send logs from containers on rancher, users deploy a logspout infrastructure stack from the EEA Helm catalog as a DaemonSet. All containers in the environment will automatically send all logs to Graylog.

If desired, specific containers can be easily excluded from sending logs to graylog by using an environment variable LOGSPOUT as example:

```
  env:
  - name: LOGSPOUT
    value: ignore
```

This chart is (almost) configured for production.

## Releases

<dl>
  <dt>Version 0.1.3</dt>
  <dd>Added kubernets version constraint.</dd>

  <dt>Version 0.1.2</dt>
  <dd>Fixed syntax error in graylog-sender.</dd>

  <dt>Version 0.1.1</dt>
  <dd>Fixed syntax error in deployment strategy.</dd>

  <dt>Version 0.1.0</dt>
  <dd>Initial version. Converted from EEA's Rancher catalogue.</dd>

</dl>

