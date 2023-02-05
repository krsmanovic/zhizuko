CREATE LOGIN GradimoZajedno WITH PASSWORD = '${zhizuko_db_password}';
GO

CREATE DATABASE ${umbraco_db_name};
GO

USE ${umbraco_db_name};
GO

CREATE USER GradimoZajedno FOR LOGIN GradimoZajedno;
GO

EXEC sp_addrolemember 'db_datareader', 'GradimoZajedno';
GO

EXEC sp_addrolemember 'db_datawriter', 'GradimoZajedno';
GO

EXEC sp_addrolemember 'db_owner', 'GradimoZajedno';
GO

USE [master];
GO

-- RESTORE DATABASE [${umbraco_db_name}]
--     FROM DISK='/tmp/GradimoZajedno/${umbraco_db_name}.bak'
--     WITH REPLACE,
--     MOVE '${umbraco_db_name}' TO '/var/opt/mssql/data/${umbraco_db_name}.mdf',
--     MOVE '${umbraco_db_name}_log' TO '/var/opt/mssql/data/${umbraco_db_name}_log.ldf';
-- GO