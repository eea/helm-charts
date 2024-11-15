# Nature Directives expert review tool

This chart is configured to require little or no configuration for development and test usage.

If you need to modify, then create a new .yaml file with the modifications.

For the database password, use the default values, or if you already have an existing database,
set the values in the database section.

## Production

It is assumed you have done helm add repo eea-charts https://eea.github.io/helm-charts/

To set the app up for Article 17 do:
    Use a private repository for the production configuration.
    Then copy art17-values.yaml from the sources and add the passwords etc.
    helm install art17 habitatsdir -f art17-values.yaml

To set the app up for Article 12 do:
    Use a private repository for the production configuration.
    Then copy art12-values.yaml from the sources and add the passwords etc.
    helm install art17 habitatsdir -f art12-values.yaml

## Releases

<dl>
  <dt>Version 0.4.6 - 15 November 2024</dt>
  <dd>Upgraded eeacms/eeacms/art17-consultation</dd>

  <dt>Version 0.4.5 - 13 November 2024</dt>
  <dd>Upgraded eeacms/art12-viewer</dd>

  <dt>Version 0.4.4 - 30 October 2024</dt>
  <dd>Upgraded eeacms/art12-viewer</dd>

  <dt>Version 0.4.3 - 3 September 2024</dt>
  <dd>Reverted incorrect use of values.yaml file. Updated version of postfix subchart to 2.0.0.</dd>

  <dt>Version 0.4.2</dt>
  <dd>Upgraded art17 ingress.</dd>

  <dt>Version 0.4.1</dt>
  <dd>Update eeacms/art17-consultation and eeacms/art12-viewer<dd>

  <dt>Version 0.4.0</dt>
  <dd>Replace mailfwd with postfix subchart.</dd>

  <dt>Version 0.3.3</dt>
  <dd>Hardwire versions of mariadb and postgresql.</dd>

  <dt>Version 0.3.2</dt>
  <dd>Also allow ingress to reach static resources.</dd>

  <dt>Version 0.3.1</dt>
  <dd>More network security policies for ingress.</dd>

  <dt>Version 0.3.0</dt>
  <dd>Added network security policy to prevent egress from database pods.</dd>

</dl>
