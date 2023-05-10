EUNIS
=====

This chart is configured to require little or no configuration for development and test usage.

If you need to modify, then create a new .yaml file with the modifications.

For the database password, use the default values, or if you already have an existing database,
set the values in the database section.

Namespace-awareness
-------------------
Since this app expects to find the database at the name `dbservice`, you can not
run two different EUNIS applications in the same namespace.
