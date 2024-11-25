# Mail forwarder

This service listens on port 25 for emails. It then sends them to a upstream
MTA using authentication.

If the `dryrun` flag is set to true, the mails will not get sent, but sent to stdout
for logging. Defaults to false. Access to the web interface that displays the collected emails 
is by default disabled. See **Values** for details

When `dryrun` is false, `mtpRelay`, `mtpPort`, `mtpUser` and `mtpPass` are mandatory 
in order to succesfully send emails.

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| debug.enable | bool | false | Set true to install the mailtrap image instead of the postfix one |
| mailtrap.httpenabled | bool | false | Set true to enable the http service in order to view the web interface |
| mailtrap.serviceType | string | NodePort | NodePort to expose the service, ClusterIP if you want to use "kubectl port-forward" |
| mailtrap.ingress.enabled | bool | false | Set true to enable ingress |
| mailtrap.ingress.hostname | string | mailtrap.01dev.eea.europa.eu | Unique url for your application, must resolve to the cluster frontend |
| mailtrap.ingress.certificate | string | mailtrap.01dev.eea.europa.eu-tls | Unique name for certificate |
| mailtrap.ingress.annotations | string | cert-manager.io/cluster-issuer: 01dev-eea-letsencrypt | Mandatory configuration for letsencrypt to work |




## Releases

### Version 3.0.3 - 25 November 2024
- Reverted the addition of `component: postfix` to labels. If you have already upgraded to
version 3.0, then delete the Deployment resource before upgrading to 3.0.3.
- Changed the names of the macros to coexist better when a subchart.

### Version 3.0.2 - 12 November 2024
- Updated the network security policy for mailtrap web interface.

### Version 3.0.1 - 11 November 2024
- Added network security policy for mailtrap web interface.

### Version 3.0.0 - 5 November 2024
- Add questions, mailtrap for development apps with ingress support

### Version 2.0.1 - 2 September 2024
- Simpler network security policy.

### Version 2.0.0
- Postfix image updated to version 3.5-1.0.
- Network policies: Only allow postfix to be used from same namespace.
    Only allow outgoing to defined mtpPort and DNS resolution.

### Version 1.1.0
- Can now set a dryrun flag.

### Version 1.0.0
- Production release. Set maxSurge and maxUnavailable to 1.

