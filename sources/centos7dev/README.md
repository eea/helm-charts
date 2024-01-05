# ALMA 9 linux (Formerly CentOS 7)

This is an example of a helm chart. It deploys a single pod with an ALMA Linux image,
which can be used for administration, or as a subchart in another helm chart.

## Mounting persistent volumes

The `mounts` value is a list of Persistent Volume Claims that will be mounted
under /mnt. The volume claims must exist already.

## Releases

<dl>
  <dt>Version 1.0.0</dt>
  <dd>Migrated to ALMA Linux 9.3 as CentOS has not been maintained by Redhat for a couple of years.
      Added network security policy that blocks inter-namespace traffic.
  </dd>

  <dt>Version 0.2.1</dt>
  <dd>Upgraded to CentOS 7.9.2009 and added rsync, openssh, elinks.</dd>

  <dt>Version 0.2.0</dt>
  <dd>Ability to mount PVCs.</dd>

  <dt>Version 0.1.0</dt>
  <dd>Initial version.</dd>
</dl>
