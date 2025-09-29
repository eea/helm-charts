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

### Version 0.4.10 - 29 September 2025
- Release on habitatsdir version 0.4.10 [Diana Boiangiu - [`bd7adc9e`](https://github.com/eea/helm-charts/commit/bd7adc9ea7e68c9bd961f11b76100c9fe65efb27)]

### Version 0.4.9 - 25 August 2025
- Release of dependent chart postfix:3.1.0 [EEA Jenkins - [`d8254400`](https://github.com/eea/helm-charts/commit/d8254400f6daf9436a933c38d5033fad6264b5a1)]


### Version 0.4.8 - 24 February 2025
- Remove unused mysql service

### Version 0.4.7 - 03 February 2025
- Upgraded eeacms/eeacms/art17-consultation

### Version 0.4.6 - 15 November 2024
- Upgraded eeacms/eeacms/art17-consultation

### Version 0.4.5 - 13 November 2024
- Upgraded eeacms/art12-viewer

### Version 0.4.4 - 30 October 2024
- Upgraded eeacms/art12-viewer

### Version 0.4.3 - 3 September 2024
- Reverted incorrect use of values.yaml file. Updated version of postfix subchart to 2.0.0.

### Version 0.4.2
- Upgraded art17 ingress.

### Version 0.4.1
  <dd>Update eeacms/art17-consultation and eeacms/art12-viewer<dd>

### Version 0.4.0
- Replace mailfwd with postfix subchart.

### Version 0.3.3
- Hardwire versions of mariadb and postgresql.

### Version 0.3.2
- Also allow ingress to reach static resources.

### Version 0.3.1
- More network security policies for ingress.

### Version 0.3.0
- Added network security policy to prevent egress from database pods.


