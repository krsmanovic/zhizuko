#cloud-config
users:
  - name: zhizuko
    gecos: Zhizuko Dot Net User
    groups: users, admin
    sudo: ALL=(ALL) NOPASSWD:ALL
    shell: /bin/bash
    passwd: ${zhizuko_user_password}
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
  - certbot
  - python3-certbot-nginx

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
- encoding: b64
  path: /etc/nginx/sites-available/${domain}.conf
  content: ${nginx_config}
- encoding: b64
  path: /etc/systemd/system/${server_name}.service
  content: ${zhizuko_unitfile}

runcmd:
  - ufw allow OpenSSH
  - ufw allow "Nginx Full"
  - ufw --force enable
  - hostnamectl set-hostname ${server_name}
  # .NET 7
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
  # Pull in project code
  - mkdir /code
  - cd /code
  - git clone https://github.com/vegaitsourcing/website-gradimo-zajedno.git
  - cd /code/website-gradimo-zajedno/GradimoZajedno.Web
  - DOTNET_CLI_HOME=/tmp dotnet publish --configuration Release --self-contained --runtime linux-x64
  - chown -R zhizuko:zhizuko /code
  # Nginx setup
  - rm -rf /etc/nginx/sites-available/default /etc/nginx/sites-enabled/default
  - ln -s /etc/nginx/sites-available/${domain}.conf /etc/nginx/sites-enabled/
  - systemctl restart nginx
  # Set up application systemd unit
  - systemctl start ${server_name}.service
  - systemctl enable ${server_name}.service
  # Enable certbot
  - certbot --nginx -d ${domain} --non-interactive --agree-tos -m ${cert_contact_email} --redirect
  # Umbraco unattended install
  # - dotnet new install Umbraco.Templates
  # - dotnet new umbraco -n zhizuko --friendly-name "${umbraco_friendly_name}" --email "${umbraco_email}" --password "${umbraco_password}" --connection-string "Server=localhost;Database=${umbraco_db_name};Integrated Security=true" --version 10.0.0

final_message: "The system is finally up, after $UPTIME seconds"