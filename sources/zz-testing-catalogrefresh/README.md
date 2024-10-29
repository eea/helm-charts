# ALMA 9 linux (Formerly CentOS 7)

This is a copy of the centos7dev app. 
We will use this to test the Rancher catalog refresh.

This is an example of a helm chart. It deploys a single pod with an ALMA Linux image,
which can be used for administration, or as a subchart in another helm chart.

## Mounting persistent volumes

The `mounts` value is a list of Persistent Volume Claims that will be mounted
under /mnt. The volume claims must exist already.

## Releases

<dl>


  <dt>Version 2.0.4</dt>
  <dd>version increase</dd>

  <dt>Version 2.0.3</dt>
  <dd>version increase</dd>

  <dt>Version 2.0.1</dt>
  <dd>version increase</dd>

  <dt>Version 2.0.0 - 29 October 2024</dt>
  <dd>Converted to catalog refresh testing app .</dd>

  <dt>Version 1.0.5 - 10 September 2024</dt>
  <dd>Allow mounts to be specified as comma-separated list.</dd>

  <dt>Version 1.0.4 - 10 September 2024</dt>
  <dd>Added questions.yaml from [Rancher documentation](https://ranchermanager.docs.rancher.com/how-to-guides/new-user-guides/helm-charts-in-rancher/create-apps)</dd>

  <dt>Version 1.0.3 - 4 September 2024</dt>
  <dd>Upgrade to AlmaLinux 9.4.</dd>

  <dt>Version 1.0.2</dt>
  <dd>Added ldap clients.</dd>

  <dt>Version 1.0.1</dt>
  <dd>Fixed typo in network security policy.</dd>

  <dt>Version 1.0.0</dt>
  <dd>Migrated to ALMA Linux 9.3 as CentOS has not been maintained by Redhat for a couple of years.
      Added network security policy that blocks inter-namespace traffic.
  </dd>

</dl>
