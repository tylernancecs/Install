#!/bin/bash
# Install script for Hub monitoring
# May 06 2020 Tyler Nance, New Script

# Makes Prometheus directory and moves into it
function prometheusPrep() {
sudo mkdir Prometheus
cd Prometheus
}



function nodeExporter() {
# Grabs node_exporter from Github and uncompresses it
sudo wget https://github.com/prometheus/node_exporter/releases/download/v1.9.0/node_exporter-1.9.0.linux-amd64.tar.gz
sudo tar -xvzf node_exporter-1.9.0.linux-amd64.tar.gz

sleep 5
# Symbolic links node_exporter to /usr/bin
cd  node_exporter-1.9.0.linux-amd64/
sudo cp --remove-destination node_exporter /usr/bin

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
sudo systemctl enable node_exporter
sudo service node_exporter start
}

function mongodbExporter() {
#Grabs mongodb_exporter from Github and uncompresses it
cd ~/Prometheus/
sudo wget https://github.com/percona/mongodb_exporter/releases/download/v0.43.1/mongodb_exporter-0.43.1.linux-amd64.tar.gz
sudo tar -xvzf mongodb_exporter-0.43.1.linux-amd64.tar.gz

sleep 5
# Copies file to /usr/bin
cd mongodb_exporter-0.43.1.linux-amd64
sudo cp --remove-destination mongodb_exporter /usr/bin

# Creates mongodb_exporter service
cat <<'EOF4' >/etc/systemd/system/mongodb_exporter.service
[Unit]
Description=mongodb_exporter
After=network.target

[Service]
ExecStart=/usr/bin/mongodb_exporter \
  --mongodb.uri=mongodb://127.0.0.1:17001

[Install]
WantedBy=multi-user.target
EOF4

# Installs and starts mongodb_exporter service
sudo systemctl enable mongodb_exporter.service
sudo service mongodb_exporter start
}

prometheusPrep
nodeExporter
mongodbExporter
