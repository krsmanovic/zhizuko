CREATE LOGIN [${zhizuko_db_login}] WITH PASSWORD='${zhizuko_db_password}';
GO

CREATE DATABASE [${umbraco_db_name}];
GO

USE [master];
GO

RESTORE DATABASE [${umbraco_db_name}]
    FROM DISK='/tmp/GradimoZajedno/GradimoZajedno.Umbraco.bak'
    WITH REPLACE,
    MOVE 'GradimoZajedno.Umbraco' TO '/var/opt/mssql/data/${umbraco_db_name}.mdf',
    MOVE 'GradimoZajedno.Umbraco_log' TO '/var/opt/mssql/data/${umbraco_db_name}_log.ldf';
GO

USE [${umbraco_db_name}];
GO

-- Fix orpahned dbo UserSID
EXEC sp_changedbowner 'sa';
GO

CREATE USER [${zhizuko_db_user}] FOR LOGIN [${zhizuko_db_login}];
GO

EXEC sp_addrolemember 'db_owner', '${zhizuko_db_user}';
GO

EXEC sp_defaultdb '${zhizuko_db_login}', '${umbraco_db_name}';
GO

-- Reset Umbraco Administrator user
UPDATE umbracoUser
SET userLogin = '${umbraco_email}',
    userEmail = '${umbraco_email}',
    userPassword = '${admin_hash}'
WHERE userName = 'Administrator';
GO