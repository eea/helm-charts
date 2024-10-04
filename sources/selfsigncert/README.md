# Self-signed certificate

This chart will generate a self-signed certificate with a duration of 10 years. The certificate is deleted when you uninstall the chart.

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| secretName | string | "" | Name of the Secret object to create. Defaults to release name. |
| commonName | string | "" | Primary DNS name of service |
| duration | int | 3650 | Duration in days |
| alternativeNames | list | [] | Alternative DNS names |
| ipNumbers | list | [] | IP number restrictions. If specified the server must match the number |

## Releases

<dl>
  <dt>0.2.1 - 4 Oct. 2024</dt>
  <dd>Declare that it deploys on both Linux and Windows.</dd>

  <dt>0.2.0 - 4 Oct. 2024</dt>
  <dd>Improvements to questions.yaml.</dd>

  <dt>0.1.0 - 2 Oct. 2024</dt>
  <dd>Initial release.</dd>
</dl>
