# idp-in-a-box

Terraform Configuration, Documentation, and examples for the IdP-in-a-Box service.

## Local Dev

To run the IdP-in-a-Box locally for development purposes, the Docker Compose environment in
the [idp-profile-ui](https://github.com/sil-org/idp-profile-ui) repository includes much of the IdP system.

## Service image version compatibility

The relevant service images are only supported at their latest major version number. At this time, the latest major 
versions are:

| image                                                        | version |
|--------------------------------------------------------------|---------|
| [db-backup](https://github.com/sil-org/mysql-backup-restore) | 4       |
| [idp-id-broker](https://github.com/sil-org/idp-id-broker)    | 8       |
| [idp-id-sync](https://github.com/sil-org/idp-id-sync)        | 5       |
| [idp-pw-api](https://github.com/sil-org/idp-pw-api)          | 8       |
| [ssp-base](https://github.com/sil-org/ssp-base)              | 11      |
