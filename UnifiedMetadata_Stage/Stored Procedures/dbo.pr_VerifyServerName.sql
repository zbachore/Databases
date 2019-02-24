SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[pr_VerifyServerName] @ServerName varchar(50)
AS
BEGIN
/**************************************************************************************************
Project:		UMTS Metadata Tool
JIRA:			UMDT-4942
Developer:		zbachore
Date:			2018-10-18
Description:	This procedure gets the name of the server - machine name.
				The name is then used in SSIS expression for metadata publishing purpose.
				This is better than using a config file so that we do not have to always
				change the value for the config file each time we deploy the package.
___________________________________________________________________________________________________
Example: 
EXEC dbo.pr_VerifyServerName 'DEVNCDRTRNDB' 
___________________________________________________________________________________________________
Revision History
Date			Author			Reason for Change

-------	 ------- -----------------------------------------------------------------------
***************************************************************************************************/
DECLARE @ErrorMessage VARCHAR(max) = 'An error occurred in procedure: ',
		@Procedure VARCHAR(MAX) =   OBJECT_NAME(@@PROCID),
		@ThisServerName VARCHAR(MAX) = @@SERVERNAME

BEGIN TRY
BEGIN TRAN;

--Converting server names into aliases.
--User Provided ServerName
--Transactional Servers:
IF @ServerName = 'DEVNCDRTRNDB1'
   OR @ServerName = 'DEVNCDRTRNDB'
    SET @ServerName = 'DEVNCDRTRNDB';
ELSE IF @ServerName = 'STGNCDRTRNDB1'
        OR @ServerName = 'STGNCDRTRNDB'
    SET @ServerName = 'STGNCDRTRNDB';
ELSE IF @ServerName = 'RLSNCDRTRNDB1'
        OR @ServerName = 'RLSNCDRTRNDB'
    SET @ServerName = 'RLSNCDRTRNDB1';
ELSE IF @ServerName = 'PRDNCDRTRNDB1'
        OR @ServerName = 'PRDNCDRTRNDB2'
        OR @ServerName = 'RDPRDNCDRTRNDB1'
        OR @ServerName = 'PRDNCDRTRNDB'
    SET @ServerName = 'PRDNCDRTRNDB';

--EDW Servers:
IF @ServerName = 'DEVNCDREDWDB1'
   OR @ServerName = 'DEVNCDREDWDB'
    SET @ServerName = 'DEVNCDREDWDB';
ELSE IF @ServerName = 'STGNCDREDWDB1'
        OR @ServerName = 'STGNCDREDWDB'
    SET @ServerName = 'STGNCDREDWDB';
ELSE IF @ServerName = 'STGNCDRICDDB1\EDW'
	SET @ServerName = 'STGNCDRICDDB1\EDW'
ELSE IF @ServerName = 'RLSNCDREDWDB1'
        OR @ServerName = 'RLSNCDREDWDB'
    SET @ServerName = 'RLSNCDREDWDB1';
ELSE IF @ServerName = 'PRDNCDREDWDB1'
        OR @ServerName = 'PRDNCDREDWDB2'
        OR @ServerName = 'RDPRDNCDREDWDB1'
        OR @ServerName = 'PRDNCDREDWDB'
    SET @ServerName = 'PRDNCDREDWDB';

--ServerName on which job is running:
--Transactional Servers:
IF @ThisServerName = 'DEVNCDRTRNDB1'
   OR @ThisServerName = 'DEVNCDRTRNDB'
    SET @ThisServerName = 'DEVNCDRTRNDB';
ELSE IF @ThisServerName = 'STGNCDRTRNDB1'
        OR @ThisServerName = 'STGNCDRTRNDB'
    SET @ThisServerName = 'STGNCDRTRNDB';
ELSE IF @ThisServerName = 'RLSNCDRTRNDB1'
        OR @ThisServerName = 'RLSNCDRTRNDB'
    SET @ThisServerName = 'RLSNCDRTRNDB1';
ELSE IF @ThisServerName = 'PRDNCDRTRNDB1'
        OR @ThisServerName = 'PRDNCDRTRNDB2'
        OR @ThisServerName = 'RDPRDNCDRTRNDB1'
        OR @ThisServerName = 'PRDNCDRTRNDB'
    SET @ThisServerName = 'PRDNCDRTRNDB';

--EDW Servers:
IF @ThisServerName = 'DEVNCDREDWDB1'
   OR @ThisServerName = 'DEVNCDREDWDB'
    SET @ThisServerName = 'DEVNCDREDWDB';
ELSE IF @ThisServerName = 'STGNCDREDWDB1'
        OR @ThisServerName = 'STGNCDREDWDB'
    SET @ThisServerName = 'STGNCDREDWDB';
ELSE IF @ThisServerName = 'RLSNCDREDWDB1'
        OR @ThisServerName = 'RLSNCDREDWDB'
    SET @ThisServerName = 'RLSNCDREDWDB1';
ELSE IF @ThisServerName = 'PRDNCDREDWDB1'
        OR @ThisServerName = 'PRDNCDREDWDB2'
        OR @ThisServerName = 'RDPRDNCDREDWDB1'
        OR @ThisServerName = 'PRDNCDREDWDB'
    SET @ThisServerName = 'PRDNCDREDWDB';

	SELECT ServerName = CAST(@ServerName AS VARCHAR(50)), 
	ThisServerName = CAST(@ThisServerName AS VARCHAR(50))

COMMIT;
END TRY
BEGIN CATCH
    IF ( @@TRANCOUNT > 0 )
            ROLLBACK TRANSACTION;
    SET @ErrorMessage = @ErrorMessage + @Procedure + ':' + ERROR_MESSAGE();
    THROW 50000, @ErrorMessage, 1
END CATCH;

END
GO
