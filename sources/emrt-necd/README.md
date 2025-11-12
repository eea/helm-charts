# Emission Review Tool - NEC Directive

The EMRT (EEA Emission Review Tool) is a web-based tool hosted by the EEA to facilitate quality checks and reviews of national emission inventories reported by EU Member States.

## Releases

### Version 2.1.1 - 12 November 2025
- User-scalable memcached

### Version 2.1.0 - 12 November 2025
- Replaced the Bitnami memcached subchart

### Version 2.0.6 - 25 August 2025
- Release of dependent chart postfix:3.1.0 [EEA Jenkins - [`469a928f`](https://github.com/eea/helm-charts/commit/469a928fc6e24f101429dd6bd169c50af8c9a461)]

### Version 2.0.5 - 05/05-2025
- Ingress: move default ingress to plone6 service.

### Version 2.0.4 - 23/04-2025
- Ingress: rewrite-target -> configuration-snippet.

### Version 2.0.3 - 16/04-2025
- Fix typo.

### Version 2.0.2 - 16/04-2025
- Attempt fixing Plone 6 ingress.

### Version 2.0.1 - 16/04-2025
- Add ingress for Plone 6.

### Version 2.0.0 - 14/04-2025
- Upgrade to plone-2.6.3. Prepare for migration.
- Add Plone 6 deployments: zeo6 (+ storage) and plone6.

### Version 1.0.2 - 25/11-2024
- Made probe timeout changeable.

### Version 1.0.1 - 25/11-2024
- Removed default targetMemoryUtilizationPercentage as it would be added when not needed.

### Version 1.0.0 - 14/11-2024
- Zeoserver is no longer on a separate host. Took out the flag.
- Upgraded postfix subchart to 3.0.2.

### Version 0.4.0 - 30/9-2024
- Added zeoserver.enabled flag to create zeoserver in the application.

### Version 0.3.9 - 05/9-2024
- Upgraded memcached to 7.4.13, upgraded postfix to 2.0.1.

### Version 0.3.8 - 20/6-2024
- Upgraded memcached to 7.4.7, upgraded postfix to 1.1.0.

### Version 0.3.7
- Upgrade to plone-2.5.51

### Version 0.3.6
- Upgrade to plone-2.5.50

### Version 0.3.5
- Upgrade to plone-2.5.49

### Version 0.3.4
- Upgrade to plone-2.5.48

### Version 0.3.3
- Change to rolling upgrades for Plone.

### Version 0.3.2
- Set a variable path to probe. Increase timeout to 2 seconds.

### Version 0.3.1
- Fix crontab job. Refs #260926.

### Version 0.3.0
- Upgraded to plone-2.5.46, added 2024 snapshot. Refs #260926 .
