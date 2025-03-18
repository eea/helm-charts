# EUNIS

This chart is configured to require little or no configuration for development and test usage.

If you need to modify, then create a new .yaml file with the modifications.

For the database password, use the default values, or if you already have an existing database,
set the values in the database section.

## Namespace-awareness

Since this app expects to find the database at the name `dbservice`, you can not
run two different EUNIS applications in the same namespace.

## Smoke test

You can run `helm test eunis` to verify the system is working correctly.

## Releases

| Version | Comment |
| ------- | ------- |
| Version 1.2.0 - 18 Mar. 2025 | More lax network security policy for Tomcat |
| Version 1.1.1 - 8 Nov. 2024 | Removed old mariadb 5 |
| Version 1.1.0 - 7 Nov. 2024 | Added mariadb service to upgrade database |
| Version 1.0.4 - 9 Aug. 2024 | Removed default annotations for Ingress. |
| Version 1.0.3 - 9 Aug. 2024 | Added startup and readyness probes. Made them optional. |
| Version 1.0.2 | Made buildsw optional, and disabled by default. |
| Version 1.0.1 | Added security policy to deny outward connections from database. |
| Version 1.0.0 | Removed readyness probe. |
| Version 0.2.0 | Added network security policies. |
| Version 0.1.3 | First version to be used in production. |
| Version 0.1.0 | Initial version. |

