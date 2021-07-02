This repository contains all the information required to construct services rooted at kory33.net.

## Setup

### Setting up the server

Run the following:

```bash
# TODO: wget setup-server.sh and run
```

### Setting up GitHub Actions

The controller container acts as a gateway for restarting & updating service containers. To allow GitHub Actions to update services, 

```bash
# add this output to the secret CONTROLLER_HOST_KEY
cat /etc/ssh/ssh_host_ed25519_key.pub | grep -oE "ssh-ed25519 [^ ]*"

# add this output to the secret CONTROLLER_AUTH_KEY
sudo cat /home/github/.ssh/id_ed25519

# once seen, remove the secret key
sudo rm /home/github/.ssh/id_ed25519
```

where the secrets are to be added from [here](https://github.com/kory33/oracle-cloud-gp-servers/settings/secrets/actions/new).

