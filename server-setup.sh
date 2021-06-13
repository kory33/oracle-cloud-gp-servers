#!/bin/bash
set -e

# setup git
git config --global user.email "korygm33@gmail.com"
git config --global user.name "Ryosuke Kondo"

sudo apt update && sudo apt upgrade -y

# region install toolchains
sudo apt-get remove -y docker docker-engine docker.io containerd runc || true
sudo apt-get install -y apt-transport-https ca-certificates curl gnupg lsb-release
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
