#!/bin/bash
set -e

apt-get -y install software-properties-common wget curl

add-apt-repository ppa:jonathonf/vim
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

wget install-node.now.sh/lts
chmod +x lts
./lts

apt update
apt install -y vim yarn
