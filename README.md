Shipyard on Rackspace Carina
========================

The following Carina TLS files should be copied to the `proxy` directory.

* ca.pem - Certificate Authority, used by clients to validate servers
* cert.pem - Client Certificate, used by clients to identify themselves to servers
* key.pem - Client Private Key, used by clients to encrypt their requests
* ca-key.pem - Certificate Authority Key, private file used to generate more client certificates.


Usage
----------------------

    Follow your usual setup (e.g. source docker.env) for Rackspace Carina to use the Docker swarm before running ./shipyard_setup.sh to deploy to the Carina environment.


    $ source docker.env
    $ ./shipyard_setup.sh
