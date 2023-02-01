#!/bin/bash -e

# Source: https://learn.microsoft.com/en-us/sql/linux/sample-unattended-install-ubuntu?view=sql-server-ver16

# Password for the SA user (required)
MSSQL_SA_PASSWORD="${mssql_sa_password}"

# Product ID of the version of SQL server you're installing
# Must be evaluation, developer, express, web, standard, enterprise, or your 25 digit product key
# Defaults to developer
MSSQL_PID="express"

# Install SQL Server Agent (recommended)
SQL_INSTALL_AGENT="y"

# Install SQL Server Full Text Search (optional)
# SQL_INSTALL_FULLTEXT='y'

# Create an additional user with sysadmin privileges (optional)
# SQL_INSTALL_USER='<Username>'
# SQL_INSTALL_USER_PASSWORD='<YourStrong!Passw0rd>'

if [ -z "$MSSQL_SA_PASSWORD" ]
then
  echo Environment variable MSSQL_SA_PASSWORD must be set for unattended install
  exit 1
fi

echo Adding Microsoft repositories...
sudo curl https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -
repoargs="$(curl https://packages.microsoft.com/config/ubuntu/20.04/mssql-server-2022.list)"
sudo add-apt-repository "$repoargs"
repoargs="$(curl https://packages.microsoft.com/config/ubuntu/20.04/prod.list)"
sudo add-apt-repository "$repoargs"

echo Running apt update -y...
sudo apt update -y

echo Installing SQL Server...
sudo apt install -y mssql-server

echo Running mssql-conf setup...
sudo MSSQL_SA_PASSWORD="$MSSQL_SA_PASSWORD" \
     MSSQL_PID=$MSSQL_PID \
     /opt/mssql/bin/mssql-conf -n setup accept-eula

echo Installing mssql-tools and unixODBC developer...
sudo ACCEPT_EULA=Y apt install -y mssql-tools unixodbc-dev

# Add SQL Server tools to the path by default:
echo Adding SQL Server tools to your path...
echo PATH="$PATH:/opt/mssql-tools/bin" >> ~/.bash_profile
echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bashrc
source ~/.bashrc

# Source: https://learn.microsoft.com/en-us/sql/linux/sql-server-linux-setup-sql-agent?view=sql-server-ver16
# For SQL Server 2017 CU3 and earlier, we had to install the SQL Server Agent package with: sudo apt install -y mssql-server-agent
# Enabling SQL Server Agent:
if [ ! -z $SQL_INSTALL_AGENT ]
then
  echo Enabling SQL Server Agent...
  /opt/mssql/bin/mssql-conf set sqlagent.enabled true
fi

# Optional SQL Server Full Text Search installation:
if [ ! -z $SQL_INSTALL_FULLTEXT ]
then
    echo Installing SQL Server Full-Text Search...
    sudo apt install -y mssql-server-fts
fi

# Configure firewall to allow TCP port 1433:
# echo Configuring UFW to allow traffic on port 1433...
# sudo ufw allow 1433/tcp
# sudo ufw reload

# Optional example of post-installation configuration.
# Trace flags 1204 and 1222 are for deadlock tracing.
# echo Setting trace flags...
# sudo /opt/mssql/bin/mssql-conf traceflag 1204 1222 on

# Restart SQL Server after installing:
echo Restarting SQL Server...
sudo systemctl restart mssql-server

# Connect to server and get the version:
counter=1
errstatus=1
while [ $counter -le 5 ] && [ $errstatus = 1 ]
do
  echo Waiting for SQL Server to start...
  sleep 3s
  /opt/mssql-tools/bin/sqlcmd \
    -S localhost \
    -U SA \
    -P "$MSSQL_SA_PASSWORD" \
    -Q "SELECT @@VERSION" 2>/dev/null
  errstatus=$?
  ((counter++))
done

# Display error if connection failed:
if [ $errstatus = 1 ]
then
  echo Cannot connect to SQL Server, installation aborted
  exit $errstatus
fi

# Optional new user creation:
if [ ! -z $SQL_INSTALL_USER ] && [ ! -z $SQL_INSTALL_USER_PASSWORD ]
then
  echo Creating user $SQL_INSTALL_USER
  /opt/mssql-tools/bin/sqlcmd \
    -S localhost \
    -U SA \
    -P "$MSSQL_SA_PASSWORD" \
    -Q "CREATE LOGIN [$SQL_INSTALL_USER] WITH PASSWORD=N'$SQL_INSTALL_USER_PASSWORD', DEFAULT_DATABASE=[master], CHECK_EXPIRATION=ON, CHECK_POLICY=ON; ALTER SERVER ROLE [sysadmin] ADD MEMBER [$SQL_INSTALL_USER]"
fi

echo Done!