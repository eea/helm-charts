# Mail forwarder

This service listens on port 25 for emails. It then sends them to a upstream
MTA using authentication.

If the `dryrun` flag is set to true, the mails will not get sent, but sent to stdout
for logging. Defaults to false.

## Releases

<dl>
  <dt>Version 2.0.1 - 2 September 2024</dt>
  <dd>Simpler network security policy.</dd>

  <dt>Version 2.0.0</dt>
  <dd>Postfix image updated to version 3.5-1.0.</dd>
  <dd>Network policies: Only allow postfix to be used from same namespace.
    Only allow outgoing to defined mtpPort and DNS resolution.</dd>

  <dt>Version 1.1.0</dt>
  <dd>Can now set a dryrun flag.</dd>

  <dt>Version 1.0.0</dt>
  <dd>Production release. Set maxSurge and maxUnavailable to 1.</dd>

</dl>

