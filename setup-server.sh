#!/bin/bash
set -e

# This is an idempotent script that
# - installs all the required toolchains
# - clones the repository https://github.com/kory33/oracle-cloud-gp-servers
#   into /home/ubuntu/oracle-cloud-gp-servers if not already done.
#   The clone is done via HTTP because the controller container has to pull the repository.
# - start the service controller,
#   which is responsible for listening to signals from GitHub actions for auto-deployments

sudo apt update && sudo apt upgrade -y

# region setup git
sudo apt install -y git
git config --global user.email "korygm33@gmail.com"
git config --global user.name "Ryosuke Kondo"
# endregion

# region install toolchains
sudo apt-get remove -y docker docker-engine docker.io containerd runc || true
sudo apt-get install -y \
  apt-transport-https \
  ca-certificates \
  curl gnupg lsb-release \
  tmux
# endregion

# region install docker
# skip prompts (see https://stackoverflow.com/questions/7519375/how-to-automatically-overwrite-the-output-file-when-running-gpg-i-e-without)
curl -fsSL https://download.docker.com/linux/ubuntu/gpg \
  | sudo gpg --batch --yes --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

echo "deb \
      [arch=arm64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] \
      https://download.docker.com/linux/ubuntu \
      $(lsb_release -cs) stable" \
      | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update && sudo apt-get install -y docker-ce docker-ce-cli containerd.io
# endregion

# region install docker-compose
sudo apt install -y python3-pip
yes | sudo pip install docker-compose
# endregion

# region commence controller (that in turn starts services)

# setup ssh for github
sudo adduser --disabled-password --gecos "" github || true

sudo mkdir -p /home/github/.ssh && cd /home/github/.ssh

# generate authentication key if not already generated
if [[ ! -e authorized_keys ]]; then
  sudo ssh-keygen -t ed25519 -f id_ed25519 -N ""
  sudo sh -c 'cat ./id_ed25519.pub >> ./authorized_keys'
  sudo rm id_ed25519.pub
fi

# clone the repository if not already done
git clone \
  https://github.com/kory33/oracle-cloud-gp-servers \
  /home/ubuntu/oracle-cloud-gp-servers || true

cd /home/ubuntu/oracle-cloud-gp-servers && git pull

sudo util/restart.sh controller

# endregion
