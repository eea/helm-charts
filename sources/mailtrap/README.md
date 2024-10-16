# Mail trapper with web interface

This service listens on port 25 for emails. It then keeps them in its local database that is reset on each re-create. 

It adds an ingress url and letsencrypt to view the emails that are currently in its database.

https://github.com/eaudeweb/edw.docker.mailtrap/tree/master


## Releases

<dl>

  <dt>Version 1.0.0</dt>
  <dd>Production release. Set maxSurge and maxUnavailable to 1.</dd>

</dl>

