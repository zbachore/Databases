SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[pr_CompareTableStructure] @ProjectID INT, @PublishQueueID INT 
AS
BEGIN 


/**************************************************************************************************
Project:		UMTS Metadata Tool
JIRA:			?
Developer:		zbachore
Date:			Jan 11 2018  8:24PM
Description:	Defines dbo.pr_CompareTableStructure stored procedure
___________________________________________________________________________________________________
Example: EXEC dbo.pr_CompareTableStructure  6,1
___________________________________________________________________________________________________
Revision History
Date			Author			Reason for Change

-------	 ------- -----------------------------------------------------------------------
***************************************************************************************************/
DECLARE @ErrorMessage VARCHAR(max),
		@RequestedTime DATETIME2 = SYSDATETIME();

		BEGIN TRY
BEGIN TRAN;

IF OBJECT_ID(N'dbo.TablesToPublish', N'U') IS NULL
BEGIN 

CREATE TABLE dbo.TablesToPublish(
	TablesToPublishID int IDENTITY(1,1) NOT NULL,
	SchemaName varchar(50) NOT NULL,
	TableName varchar(100) NOT NULL,
	PublishProcedureName varchar(100) NULL,
	CreatedDate datetime2(7) NOT NULL CONSTRAINT DF_TablesToPublish_CreatedDate  DEFAULT sysdatetime(),
	UpdatedDate datetime2(7) NOT NULL CONSTRAINT DF_TablesToPublish_UpdatedDate  DEFAULT sysdatetime(),
 CONSTRAINT PK_TablesToPublish PRIMARY KEY CLUSTERED (	TablesToPublishID ASC)
) 

END;

WITH Source AS (
SELECT Distinct
	SchemaName = t.Table_Schema,
	TableName = t.Table_Name,
	PublishProcedureName = p.name 
FROM UnifiedMetadata_Stage.INFORMATION_SCHEMA.tables t 
INNER JOIN sys.Procedures p ON 'pr_Publish' + t.Table_Name = p.name 
WHERE p.name LIKE '%Publish%'
)
MERGE INTO dbo.TablesToPublish WITH(TABLOCK) AS T
USING Source AS S ON S.TableName = T.TableName 

WHEN MATCHED AND NOT EXISTS 
(SELECT	 S.SchemaName
		,S.TableName
		,S.PublishProcedureName
		INTERSECT
SELECT	 T.SchemaName
		,T.TableName
		,T.PublishProcedureName
	)
THEN UPDATE SET 
SchemaName = S.SchemaName,
TableName = S.TableName, 
PublishProcedureName = S.PublishProcedureName, 
UpdatedDate = DEFAULT

WHEN NOT MATCHED BY SOURCE 
THEN DELETE 

WHEN NOT MATCHED BY TARGET
THEN INSERT
(	SchemaName,
	TableName, 
	PublishProcedureName 
	) VALUES (
	SchemaName,
	TableName, 
	PublishProcedureName
	);

DELETE FROM dbo.PublishLog WHERE MsgType = 'Warning';

WITH Source AS (
SELECT s.TABLE_CATALOG,
       s.TABLE_SCHEMA,
       Table_Name = ISNULL(s.TABLE_NAME, T.Table_Name),
       Column_Name = ISNULL(s.COLUMN_NAME, T.Column_Name),
       Msg = CASE
                 WHEN s.COLUMN_NAME IS NULL THEN
                     'Warning: ' + ISNULL(s.COLUMN_NAME, T.Column_Name) + ' column is missing in UnifiedMetadata database!'
                 WHEN T.COLUMN_NAME IS NULL THEN
                     'Warning: ' + T.COLUMN_NAME + 'column is missing in UnifiedMetadata_Author database,'
                     + s.TABLE_NAME
                 WHEN s.DATA_TYPE <> T.DATA_TYPE THEN
                     'Warning: data types for the ' + s.COLUMN_NAME + ' columns is different between source and target tables!'
                 WHEN s.CHARACTER_MAXIMUM_LENGTH <> T.CHARACTER_MAXIMUM_LENGTH THEN
                     'Data length of the ' + s.COLUMN_NAME
                     + ' column is different between source and target!'
				 WHEN s.IS_NULLABLE <> T.IS_NULLABLE 
				 THEN 'Warning: the IS_NULLABLE property for ' + s.Column_Name + ' columns is different between source and target!'
				 WHEN S.DateTime_Precision <> T.DateTime_Precision 
				 THEN 'Warning: the DateTime_Precision property of the ' + S.column_name + ' columns is different between source and target tables!'
                 ELSE NULL END
FROM dbo.SourceTables S
FULL JOIN UnifiedMetadata.INFORMATION_SCHEMA.COLUMNS T
        ON T.TABLE_NAME = s.TABLE_NAME
           AND T.COLUMN_NAME = s.COLUMN_NAME
           AND T.TABLE_SCHEMA = s.TABLE_SCHEMA
INNER JOIN dbo.TablesToPublish P ON T.Table_Name = P.TableName 
AND T.Table_Schema = P.SchemaName
		   )
		   INSERT INTO dbo.PublishLog
		   (
		       PublishQueueID,
			   ServerName,
		       TableName,
		       TableKeyName,
		       TableKeyValue,
			   Msg,
			   MsgType,
		       RequestedTime,
		       CompletedTime
		   )

SELECT PublishQueueID = @PublishQueueId,
	   @@SERVERNAME,
       TABLE_NAME,
       COLUMN_NAME,
       TableKeyValue = NULL,
       Msg,
	   'Warning',
       RequestedTime = @RequestedTime,
       SYSDATETIME()
FROM Source
WHERE Msg IS NOT NULL;

COMMIT;
END TRY
BEGIN CATCH
    IF ( @@TRANCOUNT > 0 )
            ROLLBACK TRANSACTION;
    SET @ErrorMessage = 'dbo.pr_CompareTableStructure:' + ERROR_MESSAGE();
    THROW 50000, @ErrorMessage, 1
END CATCH;

END


           

           
		   
GO
