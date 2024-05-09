#!/usr/bin/env bash

# Copyright (c) 2021-2024 tteck
# Author: tteck (tteckster)
# License: MIT
# https://github.com/tteck/Proxmox/raw/main/LICENSE

source /dev/stdin <<< "$FUNCTIONS_FILE_PATH"
color
verb_ip6
catch_errors
setting_up_container
network_check
update_os

msg_info "Installing Dependencies"
$STD apt-get install -y curl
$STD apt-get install -y sudo
$STD apt-get install -y mc
$STD apt-get install -y apt-transport-https
$STD apt-get install -y gnupg
msg_ok "Installed Dependencies"

msg_info "Installing Eclipse Temurin JRE"
wget -qO- https://packages.adoptium.net/artifactory/api/gpg/key/public | gpg --dearmor >/etc/apt/trusted.gpg.d/adoptium.gpg
echo "deb [arch=amd64 signed-by=/etc/apt/trusted.gpg.d/adoptium.gpg] https://packages.adoptium.net/artifactory/deb bookworm main" >/etc/apt/sources.list.d/adoptium.list
$STD apt-get update
$STD apt-get install -y temurin-17-jre
msg_ok "Installed Eclipse Temurin JRE"

msg_info "Installing MongoDB (v4.4)"
wget -qO- https://www.mongodb.org/static/pgp/server-4.4.asc | gpg --dearmor >/usr/share/keyrings/mongodb-server-4.4.gpg
echo "deb [ signed-by=/usr/share/keyrings/mongodb-server-4.4.gpg ] http://repo.mongodb.org/apt/debian bookworm/mongodb-org/4.4 main" >/etc/apt/sources.list.d/mongodb-org-4.4.list
$STD apt-get update
$STD apt-get install -y mongodb-org=4.4
msg_ok "Installed MongoDB (v4.4)"

msg_info "Installing UniFi Network Server"
wget -qO /etc/apt/trusted.gpg.d/unifi-repo.gpg https://dl.ui.com/unifi/unifi-repo.gpg
echo "deb [ arch=amd64 signed-by=/etc/apt/trusted.gpg.d/unifi-repo.gpg] https://www.ui.com/downloads/unifi/debian stable ubiquiti" >/etc/apt/sources.list.d/100-ubnt-unifi.list
$STD apt-get update
$STD apt-get install -y unifi
msg_ok "Installed UniFi Network Server"

motd_ssh
customize

msg_info "Cleaning up"
$STD apt-get -y autoremove
$STD apt-get -y autoclean
msg_ok "Cleaned"
