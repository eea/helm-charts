Eionet WebQuestionnaires 2
==========================

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
and change the mysql arguments to `mysqld --max_allowed_packet=30M --innodb_log_file_size=152MB`
