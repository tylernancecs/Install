#!/bin/bash
# Install script for Hub monitoring
# May 06 2020 Tyler Nance, New Script

# Makes Prometheus directory and moves into it
sudo mkdir Prometheus
cd Prometheus

# Grabs node_exporter from Github and uncompresses it
sudo wget https://github.com/prometheus/node_exporter/releases/download/v0.15.2/node_exporter-0.15.2.linux-amd64.tar.gz
sudo tar -xvzf ~/Prometheus/node_exporter-0.15.2.linux-amd64.tar.gz

# Symbolic links node_exporter to /usr/bin
sudo ln -s ~/Prometheus/node_exporter-0.15.2.linux-amd64/node_exporter /usr/bin

# Creates Node_exporter service
cat <<'EOF3' >/etc/systemd/system/node_exporter.service
[Unit]
Description=node_exporter
After=network.target

[Service]
ExecStart=/usr/bin/node_exporter

[Install]
WantedBy=multi-user.target
EOF3

# Installs and starts node_exporter service
sudo systemctl enable node_exporter.service
sudo service node_exporter start


#Grabs mongodb_exporter from Github and uncompresses it
sudo wget https://github.com/percona/mongodb_exporter/releases/download/v0.3.1/mongodb_exporter-0.3.1.linux-amd64.tar.gz
sudo tar -xvzf ~/Prometheus/mongodb_exporter-0.3.1.linux-amd64.tar.gz

# Symbolic links mongodb_exporter to /usr/bin
sudo ln -s ~/Prometheus/mongodb_exporter-0.3.1.linux-amd64/mongodb_exporter /usr/bin

# Creates mongodb_exporter service
cat <<'EOF4' >/etc/systemd/system/mongodb_exporter.service
[Unit]
Description=mongodb_exporter
After=network.target

[Service]
ExecStart=/usr/bin/mongodb_exporter

[Install]
WantedBy=multi-user.target
EOF4

# Installs and starts mongodb_exporter service
sudo systemctl enable mongodb_exporter.service
sudo service mongodb_exporter start
