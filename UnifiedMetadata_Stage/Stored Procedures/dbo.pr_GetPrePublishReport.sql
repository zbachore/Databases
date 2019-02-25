SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[pr_GetPrePublishReport] 
@TableName VARCHAR(MAX), 
@PublishQueueID INT,
@Debug INT = 0
AS
BEGIN
/**************************************************************************************************
Project:		Publishing Algorithm
JIRA:			[Ticket # here]
Developer:		zbachore
Date:			2018-10-02
Description:	This procedure loads data to the target table incrementally
___________________________________________________________________________________________________
Example: 
EXEC dbo.pr_GetPrePublishReport 'PopulationDataElement', 1378
___________________________________________________________________________________________________
Revision History
Date			Author			Reason for Change

-------	 ------- -----------------------------------------------------------------------
***************************************************************************************************/
DECLARE @ErrorMessage VARCHAR(max) = 'An error occurred in procedure: ',
		@RequestedTime DATETIME2 = SYSDATETIME(),
		@Procedure VARCHAR(MAX) =   OBJECT_NAME(@@PROCID);

BEGIN TRY
BEGIN TRAN;

SELECT DISTINCT TableName 
TableName FROM CommonDMStage.stg.PublishLog
WHERE PublishQueueID = @PublishQueueID
--AND msgType = 'PrePublish'

DECLARE @SQL VARCHAR(MAX),
		@TableList varchar(MAX),
		@SourceColumnList VARCHAR(MAX),
		@PrimaryKeyList VARCHAR(MAX),
		@PrimaryKeyName VARCHAR(MAX),
		@SourceTable VARCHAR(MAX),
		@TargetTable varchar(MAX),
		@TableSchema VARCHAR(MAX),
		@CompareValues VARCHAR(MAX),
		@FULLJoin VARCHAR(MAX),
		@SourceOrTargetPrimaryKeys VARCHAR(MAX);
		--SELECT TOP 1 @TableName = TableName FROM stg.PublishLog
		--								WHERE PublishQueueID = @PublishQueueID
		--								AND msgType = 'PrePublish'
		--								AND TableName = @TableName
		--								--AND TableName = 'RegistryElements'

		SELECT TOP 1 @PrimaryKeyName = TableKeyName FROM CommonDMStage.stg.PublishLog
										WHERE msgType = 'PrePublish'
										AND TableName = @TableName
		SELECT @TableSchema = Table_Schema FROM CommonDM.INFORMATION_SCHEMA.Tables 
		WHERE TABLE_NAME = @TableName
		SET @SourceOrTargetPrimaryKeys = @PrimaryKeyName + '=IsNULL(S.' + @PrimaryKeyName + ',T.'+@PrimaryKeyName + '),'
	    SET @SourceTable = ' FROM UnifiedMetadata_Author.' + @TableSchema + @TableName + ' S'
		SET @TargetTable = ' UnifiedMetadata_Stage.' + @TableSchema + @TableName + ' T'


SELECT @SourceColumnList = COALESCE(@SourceColumnList + ', ', '') + 'S.' + COLUMN_NAME + ',T.' + COLUMN_NAME
FROM CommonDM.INFORMATION_SCHEMA.Columns 
WHERE Table_Name = @TableName
AND Column_Name NOT IN ('InsertTime','UpdatedBy','CreatedDate','UpdatedDate','SysStartTime','SysEndTime','UpdateTime')
AND COLUMN_NAME <> @PrimaryKeyName

--SELECT @SourceColumnList

--Compare Columns:
SELECT @CompareValues = COALESCE(@CompareValues + ' OR ', '') + 'S.' + COLUMN_NAME + '<> T.' + COLUMN_NAME
FROM CommonDM.INFORMATION_SCHEMA.Columns 
WHERE Table_Name = @TableName
AND Column_Name NOT IN ('InsertTime','UpdatedBy','CreatedDate','UpdatedDate','SysStartTime','SysEndTime','UpdateTime')
AND COLUMN_NAME <> @PrimaryKeyName --exclude PrimaryKey

SELECT @CompareValues = 'DMLAction = CASE WHEN ' + @CompareValues + ' THEN ''Updated''
WHEN S.' + @PrimaryKeyName + ' IS NULL THEN ''Deleted''
WHEN T.' + @PrimaryKeyName + ' IS NULL THEN ''Inserted''ELSE ''None'' END,' 

--SELECT @CompareValues

SELECT 
	@PrimaryKeyList = COALESCE(@PrimaryKeyList + ', ', '') + 
	CAST(TableKeyValue AS VARCHAR(MAX))
FROM stg.PublishLog 
WHERE msgType = 'PrePublish'
AND TableName = @TableName

SET @FULLJoin = ' FULL JOIN ' + @TargetTable + ' ON S.' + @PrimaryKeyName + ' = T.' + @PrimaryKeyName 
SELECT @PrimaryKeyList = ' WHERE S.' + @PrimaryKeyName + ' IN (' + @PrimaryKeyList + ' )
OR T.' + @PrimaryKeyName + ' IN (' + @PrimaryKeyList + ' )'
--SELECT @PrimaryKeyList
--SELECT @SourceColumnList
SET @SQL = 'SELECT ' + @SourceOrTargetPrimaryKeys + @CompareValues + @SourceColumnList + @SourceTable + @FULLJoin + @PrimaryKeyList 

IF @Debug = 1
  SELECT @SQL
ELSE
EXEC(@SQL)
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
