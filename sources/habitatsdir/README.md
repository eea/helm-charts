## Nature Directives expert review tool

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

  <dt>Version 0.3.0</dt>
  <dd>Added network security policy to prevent egress from database pods.</dd>

</dl>
