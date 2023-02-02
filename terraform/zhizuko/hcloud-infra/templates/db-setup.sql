CREATE LOGIN zhizuko WITH PASSWORD = '${zhizuko_db_password}';
GO

CREATE DATABASE ${umbraco_db_name};
GO

USE ${umbraco_db_name};
GO

CREATE USER zhizuko FOR LOGIN zhizuko;
GO

EXEC sp_addrolemember 'db_datareader', 'zhizuko';
GO

EXEC sp_addrolemember 'db_datawriter', 'zhizuko';
GO

EXEC sp_addrolemember 'db_owner', 'zhizuko';
GO