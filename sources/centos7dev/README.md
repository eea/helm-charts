# CentOS 7 linux

This is an example of a helm script. It deploys a single pod with a CentOS 7 Linux,
which can be used for administration.

## Mounting persistent volumes

The `mounts` value is a list of Persistent Volume Claims that will be mounted
under /mnt. The volume claims must exist already.

## Releases

<dl>
  <dt>Version 0.2.1</dt>
  <dd>Upgraded to CentOS 7.9.2009 and added rsync, openssh, elinks.</dd>

  <dt>Version 0.2.0</dt>
  <dd>Ability mount PVCs.</dd>

  <dt>Version 0.1.0</dt>
  <dd>Initial version.</dd>
</dl>
