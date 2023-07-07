# CentOS 7 linux

This is an example of a helm script. It deploys a single pod with a CentOS 7 Linux,
which can be used for administration.

## Mounting persistent volumes

The `mounts` value is a list of Persistent Volume Claims that will be mounted
under /mnt. The volume claims must exist already.
