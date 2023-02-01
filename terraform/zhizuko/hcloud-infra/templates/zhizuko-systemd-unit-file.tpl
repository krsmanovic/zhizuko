[Unit]
Description=Zhizuko web service

[Service]
WorkingDirectory=/code/website-gradimo-zajedno
ExecStart=/usr/bin/dotnet /code/website-gradimo-zajedno/GradimoZajedno.Web/bin/Release/net6.0/linux-x64/publish/GradimoZajedno.Web.dll
Restart=always
# Restart service after 10 seconds if the dotnet service crashes:
RestartSec=10
KillSignal=SIGINT
SyslogIdentifier=${app}
User=${app}
Environment=ASPNETCORE_ENVIRONMENT=Production
Environment=DOTNET_PRINT_TELEMETRY_MESSAGE=false
Environment=DOTNET_CLI_HOME=/tmp

[Install]
WantedBy=multi-user.target