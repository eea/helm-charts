# Eionet WebQuestionnaires 2

This chart is configured to require little or no configuration for development and test usage.

If you need to modify, then create a new .yaml file with the modifications.

You can set an initial admin user by entering values in

    initialAdminUsername: ""
    initialAdminPassword: ""

For the database password, use the default values, or if you already have an existing database,
set the values in the database section.

Production deployment
---------------------
For deployment into production you will have to activate the ingress, set higher memory limits,
and change the database command to:
```
database:
  command:
    - mysqld
    - '--user=mysql'
    - '--max_allowed_packet=30M'
    - '--innodb_log_file_size=152MB'
```

## Release notes

<dl>
  <dt>Version 1.0.3</dt>
  <dd>Removed debugging info</dd>

  <dt>Version 1.0.2</dt>
  <dd>Minor change to documentation</dd>

  <dt>Version 1.0.1</dt>
  <dd>Added max body size for the ingress and set it to 30M.</dd>

  <dt>Version 1.0.0</dt>
  <dd>Changed 0.5.0 to 1.0.0.</dd>

  <dt>Version 0.5.0</dt>
  <dd>Autoscaling works, but is disabled by default. Memory reservation for webq must be set
  to minimum 512Mi to scale correctly.</dd>

  <dt>Version 0.4.0</dt>
  <dd>First version to be used in production.</dd>

</dl>
