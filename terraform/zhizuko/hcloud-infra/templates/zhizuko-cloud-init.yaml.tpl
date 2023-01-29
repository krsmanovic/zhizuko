#cloud-config
users:
  - name: ops
    groups: users, admin
    sudo: ALL=(ALL) NOPASSWD:ALL
    shell: /bin/bash
package_update: true
package_upgrade: true
package_reboot_if_required: false

# Disable password authentication for root user
ssh_pwauth: false

# Install required packages
packages:
  - git
  - apt-transport-https
  - ca-certificates
  - curl
  - dos2unix
  - gnupg-agent
  - software-properties-common
  - jq
  - net-tools

# ansible:
#   install_method: pip
#   pull:
#     url: "https://github.com/krsmanovic/zhizuko.git"
#     playbook_name: hook.yml

# Write MSSQL installation script to file system
write_files:
- encoding: b64
  path: /tmp/mssql-install.sh
  content: ${mssql_install_script}

# Run ad-hoc setup
runcmd:
  - ufw allow OpenSSH
  - ufw --force enable
  - hostnamectl set-hostname ${server_name}
  # .NET 7 is not included in Ubuntu 20.04 packages
  - wget https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
  - dpkg -i packages-microsoft-prod.deb
  - rm packages-microsoft-prod.deb
  - apt update -y
  - apt install -y aspnetcore-runtime-7.0
  - apt install -y dotnet-sdk-7.0
  # MSSQL
  - dos2unix /tmp/mssql-install.sh # make sure we are not using CR LF (Windows) control characters
  - chmod +x /tmp/mssql-install.sh
  - /tmp/mssql-install.sh
  # - wget -qO- https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -
  # - add-apt-repository -y "$(wget -qO- https://packages.microsoft.com/config/ubuntu/20.04/mssql-server-2022.list)"
  # - apt update -y
  # - apt install -y mssql-server
  # - systemctl start mssql-server.service
  # - systemctl enable mssql-server.service
  # Umbraco unattended install
  - dotnet new install Umbraco.Templates
  - dotnet new umbraco -n zhizuko --friendly-name "${umbraco_friendly_name}" --email "${umbraco_email}" --password "${umbraco_password}" --connection-string "Server=localhost;Database=${umbraco_db_name};Integrated Security=true" --version 10.0.0

final_message: "The system is finally up, after $UPTIME seconds"