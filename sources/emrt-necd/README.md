# Emission Review Tool - NEC Directive

The EMRT (EEA Emission Review Tool) is a web-based tool hosted by the EEA to facilitate quality checks and reviews of national emission inventories reported by EU Member States.

## Releases

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
