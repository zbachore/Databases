SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[pr_RefreshUnifiedMetadataToStg]
AS
/*DECLARE @PackagePath VARCHAR(500) = '\\stgdb2\SSIS\UnifiedMetadataRefresh\ExtractUnifiedMetadata.dtsx'
DECLARE @ConfigPath VARCHAR(500) = '\\stgdb2\SSIS\UnifiedMetadataRefresh\ExtractUnifiedMetadata.dtsConfig'
DECLARE @SQL VARCHAR(1000)
SET @SQL = 'dtexec /F "' + ltrim(rtrim(@PackagePath)) + '"' + ' /CONFIGFILE "' + @ConfigPath + '"'

Exec master..xp_cmdshell @SQL
*/
IF EXISTS(SELECT 1 FROM dbo.PublishLog WHERE StatusID = 1)
	RAISERROR('There is already a request in the queue', 16, 1)
ELSE IF EXISTS(SELECT 1 FROM dbo.PublishLog WHERE StatusID = 2)
	RAISERROR('The request in in progress. Please wait until it is complete to place another request', 16, 1)
ELSE
	INSERT INTO dbo.PublishLog
	        ( StatusID, ServerName, UpdatedDate )
	VALUES  ( 1, -- StatusID - int
	          'STGNCDRTRNDB', -- ServerName - varchar(50)
	          GETDATE()  -- UpdatedDate - datetime
	          )
GO
