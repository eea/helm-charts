# EEA - Logspout

Glider Labs Logspout for docker logs to logcentral.

Logspout Agents: To send logs from containers on rancher, users deploy a logspout infrastructure stack from the EEA Helm catalog as a DaemonSet. All containers in the environment will automatically send all logs to Graylog.

If desired, specific containers can be easily excluded from sending logs to graylog by using an environment variable LOGSPOUT as example:

```
  env:
  - name: LOGSPOUT
    value: ignore
```

This chart is (almost) configured for production.
