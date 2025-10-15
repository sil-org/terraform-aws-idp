# idp-in-a-box
Terraform Configuration, Documentation, examples, and Docker Compose dev setup for the
IdP-in-a-Box service.

## bringing up idp-in-a-box locally using Docker Compose
1. Edit /etc/hosts or equivalent to assign `pw-api.local`, `pw-ui.local`, and
   `ssp.local` to 127.0.0.1.
2. Create `local.env` files in each of the subfolders there, using the existing
   `local.env.dist` files as guides where applicable.
3. `cd docker-compose`
4. `./up`
5. open browser to `localhost:51052`

## Service image version compatibility

The relevant service images are only supported at their latest major version number. At this time, the latest major 
versions are:

| image                                                        | version |
|--------------------------------------------------------------|---------|
| [db-backup](https://github.com/sil-org/mysql-backup-restore) | 4       |
| [idp-id-broker](https://github.com/sil-org/idp-id-broker)    | 8       |
| [idp-id-sync](https://github.com/sil-org/idp-id-sync)        | 5       |
| [idp-pw-api](https://github.com/sil-org/idp-pw-api)          | 7       |
| [ssp-base](https://github.com/sil-org/ssp-base)              | 11      |
