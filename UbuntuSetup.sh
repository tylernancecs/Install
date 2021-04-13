#!/bin/bash
# Install script for base Hub MongoDB
# May 06 2020 Tyler Nance, Base install working


# Installs Mongodb
function InstallMongoDB ()
{
	wget -qO - https://www.mongodb.org/static/pgp/server-3.2.asc | sudo apt-key add -
	echo "deb http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.2 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.2.list
	sudo apt-get update
	sudo apt-get install -y mongodb-org
}


# Configures mongod, edits to paths need to have permissons changed to mongo user
function ConfigureMongoDB ()
{
cat <<'EOF1' >/etc/mongod.conf
# mongod.conf

# for documentation of all options, see:
#   http://docs.mongodb.org/manual/reference/configuration-options/

# Where and how to store data.
storage:
  dbPath: /var/lib/mongodb
  journal:
    enabled: true
  engine: "wiredTiger"
  wiredTiger:
    collectionConfig:
      blockCompressor: snappy

# where to write logging data.
systemLog:
  destination: file
  logAppend: true
  path: /var/log/mongodb/mongod.log

# network interfaces
net:
  port: 27017

#Comment out this section if not replicating
replication:
  oplogSizeMB: 10240
  replSetName: "CentralSquare"

#sharding:

## Enterprise-Only Options:

#auditLog:

#snmp:
EOF1
}


# Configures mongod service
function ConfigureMongoDBService ()
{
cat <<'EOF2' >/etc/systemd/system/mongod.service
[Unit]
Description=High-performance, schema-free document-oriented database
After=network.target

[Service]
User=mongodb
LimitNOFILE=1000000
ExecStart=/usr/bin/mongod -quiet -config /etc/mongod.conf

[Install]
WantedBy=multi-user.target
EOF2
}


function EnableMongoDB
{
sudo systemctl enable mongod
}


function StartMongoDB ()
{
sudo service mongod start
}


function UpdateHostsFile()
{
sudo nano /etc/hosts
}

InstallMongoDB
ConfigureMongoDB
ConfigureMongoDBService
EnableMongoDB
UpdateHostsFile
StartMongoDB
