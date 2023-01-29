# General
application_name = "Zhizuko"
server_name      = "zhizuko"

# Server specific
hcloud_location   = "nbg1"         # Nuremberg
server_type       = "cx21"         # 2 Intel vCPU cores, 4 GB RAM, 40 GB root volume size, 20 TB of traffic
server_base_image = "ubuntu-20.04" # MS SQL server is not compatible with Ubuntu 22.04
ssh_key_name      = "ck-win10"

# Housekeeping
app_specific_labels = {
  Database = "MSSQL"
  Platform = "DotNet7"
  Software = "Umbraco"
}