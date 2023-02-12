# General
application_name = "zhizuko"
application_fqdn = "gradimozajedno.sadecom.org.rs"
server_name      = "zhizuko"

# Server specific
hcloud_location   = "nbg1"         # Nuremberg
server_type       = "cx21"         # 2 Intel vCPU cores, 4 GB RAM, 40 GB root volume size, 20 TB of traffic
server_base_image = "ubuntu-20.04" # MS SQL server is not compatible with Ubuntu 22.04
ssh_key_name      = "ck-win10"

# Umbraco
umbraco_user_name = "zhizuko"
umbraco_version   = "10.2.1"