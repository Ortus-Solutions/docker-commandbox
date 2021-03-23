#!/bin/bash
set -e

set $returnTo = $pwd

cd /tmp
curl -L -O https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-7.11.1-amd64.deb
sudo dpkg -i filebeat-7.11.1-amd64.deb
rm -f filebeat-7.11.1-amd64.deb

cd $returnTo

# apt-get update && apt-get install --assume-yes \
#                                 wget \
#                                 gnupg \
#                                 libreadline-dev

# Install Filebeat
# wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | apt-key add -
# echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" | tee -a /etc/apt/sources.list.d/elastic-7.x.list
# apt-get update && apt-get install -y apt-transport-https filebeat

# Cleanup before the layer is committed
apt-get clean autoclean
apt-get autoremove -y
rm -rf /var/lib/apt/lists/*