Unified Notification Service
============================

This chart is configured to require little or no configuration for development and test usage.

If you need to modify, then create a new .yaml file with the modifications.

For the database password, use the default values, or if you already have an existing database,
set the values in the database section.

## Releases

### Version 0.4.2 - 18 December 2025
- Release of dependent chart postfix:3.2.0 [EEA Jenkins - [`1c2f92ca`](https://github.com/eea/helm-charts/commit/1c2f92cacef9055b1a5fb7061faa595f4f5f1f33)]

### Version 0.4.1
- CI/CD fix.

### Version 0.4.0
- Ci fixes, HQL fixes, libraries upgrades.

### Version 0.3.8 - 25 August 2025
- Release of dependent chart postfix:3.1.0 [EEA Jenkins - [`b305c02c`](https://github.com/eea/helm-charts/commit/b305c02c474c577c079c0e84b4029fdef4194e1f)]
### Version 0.3.7
- Use of bitnamilegacy repository.

### Version 0.3.6
- Libraries upgrades.

### Version 0.3.5
- Updated helpdesk email address.

### Version 0.3.4
- UTF-8 charset for plain/html email body.

### Version 0.3.3
- Unicode error fix in notification creation.

### Version 0.3.2
- Notification generation fix, Upgrade postfix subchart to 3.0.2.

### Version 0.3.1
- Upgrade postfix subchart to 2.0.1, dependencies update, ClassCastException fix.

### Version 0.3.0
- Switch to mariadb subchart.

### Version 0.2.1 - 20 Aug. 2024
- Upgrade postfix subchart to 1.1.0.

### Version 0.2.0
- Switch to postfix subchart.

### Version 0.1.5
- Preparation to switch to postfix subchart.

### Version 0.1.4
- Update mailsvc-deployment.yaml.

### Version 0.1.0
- Initial version.



