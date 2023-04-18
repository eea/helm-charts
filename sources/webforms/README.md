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

Issues
------
It might not be possible to upgrade as the database can't be running in two instances at 
the same time. This will have to be investigated. However, since the database is a
StatefulSet, you can delete the app. The persistent volume will not be deleted. And
then you can install again.
