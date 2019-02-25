SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

	CREATE PROCEDURE [dbo].[pr_PublishAll] 
					@ProjectID INT, 
					@PublishQueueID INT, 
					@Schema VARCHAR(MAX) = NULL,
					@Table Sysname = NULL,
					@PrintSql BIT = 0
	AS BEGIN 

	SET NOCOUNT ON

	/*************************************************************************
	Project:		UMTS Metadata Tool
	JIRA:			?
	Developer:		zbachore
	Date:			Jan 27 2019  8:24PM
	Description:	This stored procedure is used to publish metadata tables.
					Tables that need to be published must be added to
					the dbo.AllTables. When a new column is added to a table
					in UnifiedMetadata_Author, we have to modify add the new
					column in UnifiedMetadata_Stage and UnifiedMetadata in the
					on the target server. In addition, we need to re-map the 
					SSIS package to extract this newly added column
	__________________________________________________________________________
	Examples: 
	EXEC dbo.pr_PublishAll 6, 1,'rdd','RegistryVersions_ValueSetMembers',1 --to print SQL
	EXEC dbo.pr_PublishAll 6, 111 --to Publish all tables
	__________________________________________________________________________
	Revision History
	Date			Author			Reason for Change
	-------------- -----------------------------------------------------------
	**************************************************************************/
	DECLARE @ErrorMessage VARCHAR(max) = '',
			@Procedure VARCHAR(MAX) =   OBJECT_NAME(@@PROCID),
			@MinID INT,
			@MaxID INT;

	BEGIN TRY
	BEGIN TRAN;
	
	TRUNCATE TABLE dbo.TableList;

	WITH Source AS (
	select DISTINCT TableSchema = T.Table_Schema,
		   TableName = T.Table_Name,
		   TablePrimaryKey = U.Column_Name,
		   a.ProjectTableName,
		   SourceJoin =  'S.'+ U.Column_Name + '=P.ReferenceId',
		   TargetJoin = 'S.' + U.Column_Name + '=T.' + U.Column_Name
	FROM Information_Schema.tables T 
	INNER JOIN dbo.AllTables a --add/remove tables to this table as needed
		ON a.TableName = T.TABLE_NAME 
		AND a.TableSchema = T.Table_Schema 
		AND a.IsPublished = 1
	inner join Information_Schema.key_column_usage U
		ON U.Table_Name = T.Table_Name
		AND U.Table_Schema = T.Table_Schema
	inner join Information_Schema.table_constraints C
		ON C.constraint_name = U.constraint_name
		AND C.constraint_type = 'PRIMARY KEY'
	where T.Table_Schema in ( 'cdd', 'dd', 'ld', 'form', 'rdd' )
		AND T.Table_Name not like '%[0-9]%'
	)

	INSERT INTO dbo.TableList
	(
		TableSchema,
		TableName, 
		TablePrimaryKey,
		ProjectTableName, 
		SourceJoin, 
		TargetJoin, 
		Source, 
		MergeSource,
		CompareColumns, 
		UpdateColumns, 
		InsertColumns
		)
	SELECT Distinct
		S.TableSchema,
		S.TableName,
		S.TablePrimaryKey,
		S.ProjectTableName,
		S.SourceJoin,
		S.TargetJoin,
		Source = 'With Source AS(SELECT S.*, P.Action FROM ' + S.TableSchema + '.' + S.TableName + ' S
		INNER JOIN ' + S.ProjectTableName + ' P
		ON ' + S.SourceJoin + ' 
		WHERE P.ProjectID = ' + CAST(@ProjectID AS VARCHAR) + '
		)',
		MergeSource = 'MERGE INTO UnifiedMetadata.' + S.TableSchema + '.' + S.TableName + 
		' With(TABLOCK) AS T
		USING Source AS S ON ' + S.TargetJoin,
		'PlaceHolder',
		'PlaceHolder',
		'PlaceHolder'
	FROM Source S

	--Initialize variables to loop:
	SELECT @MinID = (SELECT MIN(TableListID) 
						FROM dbo.TableList)
	SELECT @MaxID = (SELECT max(TableListID) 
						FROM dbo.TableList)
	WHILE @MinID <= @MaxID
	BEGIN

	DECLARE @TablePrimaryKey VARCHAR(MAX)= ' ',
		@Compare1 VARCHAR(MAX)=NULL,
		@Compare2 VARCHAR(MAX)=NULL,
		@Update VARCHAR(MAX) = NULL,
		@TableSchema varchar(MAX)=NULL,
		@Insert VARCHAR(MAX)=NULL,
		@TableName Sysname,
		@Audit VARCHAR(MAX)=NULL,
		@CatchBlock VARCHAR(MAX) = NULL,
		@Delete VARCHAR(MAX),
		@ProjectTableName VARCHAR(MAX)

	SELECT @TableName = TableName,
		   @TableSchema = TableSchema,
		   @TablePrimaryKey = TablePrimaryKey,
		   @ProjectTableName = ProjectTableName
	FROM dbo.TableList
	WHERE TableListID = @MinID;

	--Get source columns:
	SELECT @Compare1 = COALESCE(@Compare1 + ', ', '') + '
	S.' + Column_Name
	FROM Information_Schema.columns 
	WHERE Table_Name = @TableName
	AND Table_Schema = @TableSchema
	AND Column_Name NOT IN ('UpdatedBy','CreatedDate','UpdatedDate', @TablePrimaryKey)

	--Get target columns:
	SELECT @Compare2 = COALESCE(@Compare2 + ', ', '') + '
	T.' + Column_Name
	FROM Information_Schema.columns 
	WHERE Table_Name = @TableName
	AND Table_Schema = @TableSchema
	AND Column_Name NOT IN ('UpdatedBy','CreatedDate','UpdatedDate', @TablePrimaryKey)

	--Compare source and target and then update:
	UPDATE dbo.TableList 
	SET CompareColumns = '
	/*Check for any differences and update below:*/
	WHEN MATCHED AND NOT EXISTS 
	(
	SELECT ' +@Compare1 + ' 
	INTERSECT 
	SELECT '+ @Compare2 + '
	)'
	WHERE TableListID = @MinID 

	--Updates
	SELECT @Update = COALESCE(@Update + ',', '') + Column_Name + '=S.' + Column_Name
	FROM Information_Schema.columns 
	WHERE Table_Name = @TableName
	AND Column_Name NOT IN ('CreatedDate','UpdatedDate', @TablePrimaryKey)

	SELECT @Update = ' 
	THEN UPDATE SET ' + @Update + ',
	UpdatedDate = DEFAULT
	' 

	UPDATE dbo.TableList 
	SET UpdateColumns = @Update
	WHERE TableListID = @MinID 

	--Inserts:
	SELECT @Insert = COALESCE(@Insert + ', ', '') + Column_Name
	FROM Information_Schema.columns 
	WHERE Table_Name = @TableName
	AND Table_Schema = @TableSchema
	AND Column_Name NOT IN ('CreatedDate', 'UpdatedDate')

	SELECT @Insert = '

	/*Insert new rows below:*/
	WHEN NOT MATCHED BY TARGET 
	AND ISNULL(S.Action,''N'') <> ''DELETED''
	THEN INSERT 
	(' + @Insert + '
	) VALUES(
	' + @Insert + '
	)'

	UPDATE dbo.TableList 
	SET InsertColumns = @Insert
	WHERE TableListID = @MinID 

	--Deletes:
	SELECT @Delete = CHAR(13) + '
	/*Delete rows that have been deleted below:*/
	WHEN MATCHED AND S.Action = ''DELETED''
	THEN DELETE'

	UPDATE dbo.TableList 
	SET Deletes = @Delete
	WHERE TableListID = @MinID 

	SELECT @Audit =  '/*Insert auditing information below:*/
	OUTPUT  ' +
		CAST(@PublishQueueID AS VARCHAR(MAX)) + ',
		@@SERVERNAME,' +
		'''' + @TableName +''','+ 
		'''' + CAST(@TablePrimaryKey AS VARCHAR) + ''', 
		ISNULL(inserted.' + @TablePrimaryKey + ', deleted.' + @TablePrimaryKey + '), 
		CASE WHEN deleted.' + @TablePrimaryKey + ' IS NULL 
		AND Inserted.' + @TablePrimaryKey + ' IS NOT NULL 
		THEN ''Inserted''
		WHEN deleted.' + @TablePrimaryKey + ' IS NOT NULL 
		AND Inserted.' + @TablePrimaryKey + ' IS NOT NULL 
		THEN ''Updated''
		WHEN deleted.' + @TablePrimaryKey + ' IS NOT NULL 
		AND Inserted.' + @TablePrimaryKey + ' IS NULL 
		THEN ''Deleted''
		ELSE NULL END,
		''Publish'',' +
		'@RequestedTime,
		SYSDATETIME()
	INTO dbo.PublishLog;'

	UPDATE dbo.TableList 
	SET [Audit] = @Audit 
	WHERE TableListID = @MinID 

	--Error Report:
	SELECT @CatchBlock ='
	COMMIT;
	END TRY
	BEGIN CATCH
		IF ( @@TRANCOUNT > 0 )
				ROLLBACK TRANSACTION;
		SET @ErrorMessage = Error_Message();
		THROW 50000, @ErrorMessage,1
	END CATCH;'

	UPDATE dbo.TableList 
	SET CatchBlock = @CatchBlock
	WHERE TableListID = @MinID 

	SET @MinID = @MinID + 1
	END

	IF @PrintSql = 1 
	BEGIN

	DECLARE @ExecSQL nvarchar(MAX)

	SELECT @ExecSQL = '' +
		cast(BeginTran as varchar(max)) + ' ' +
		cast(Source as varchar(max))+ ' ' +
		cast(MergeSource as varchar(max))+ ' ' +
		cast(Deletes AS varchar(max))+ ' ' +
		cast(CompareColumns as varchar(max))+ ' ' +
		cast(UpdateColumns as varchar(max))+ ' ' +
		cast(InsertColumns AS varchar(max))+ ' ' +
		cast(Audit AS varchar(max))+ ' ' +
		cast(CatchBlock as varchar(max))
	FROM dbo.TableList
	WHERE TableSchema = @Schema 
	and TableName = @Table

	SELECT @ExecSQL
	END

	ELSE
	BEGIN

	--Initialize variales for this loop:
	SET @MinID = (SELECT MIN(TableListID) 
					FROM dbo.TableList)
	SET @MaxID = (SELECT max(TableListID) 
					FROM dbo.TableList)

	WHILE @MinID <= @MaxID
	BEGIN
	BEGIN TRY
	SELECT @ExecSQL = '' +
		cast(BeginTran as varchar(max)) + ' ' +
		cast(Source as varchar(max))+ ' ' +
		cast(MergeSource as varchar(max))+ ' ' +
		cast(Deletes AS varchar(max))+ ' ' +
		cast(CompareColumns as varchar(max))+ ' ' +
		cast(UpdateColumns as varchar(max))+ ' ' +
		cast(InsertColumns AS varchar(max))+ ' ' +
		cast(Audit AS varchar(max))+ ' ' +
		cast(CatchBlock as varchar(max))
	FROM dbo.TableList
	WHERE TableListID = @MinID

		SELECT @TableSchema = TableSchema
		FROM dbo.TableList
		WHERE TableListID = @MinID;
		SELECT @TableName = TableName
		FROM dbo.TableList
		WHERE TableListID = @MinID;

	PRINT 'Publishing ' + @TableSchema + '.' + @TableName + ' Started:   ' + 
	CAST(SYSDATETIME() AS VARCHAR(MAX))
	EXEC sp_executesql @ExecSQL
	PRINT 'Publishing ' + @TableSchema + '.' + @TableName + ' Completed: ' + 
	CAST(SYSDATETIME() AS VARCHAR(MAX))


	END TRY

	BEGIN CATCH
		SET @ErrorMessage = ERROR_MESSAGE();
		THROW 50000, @ErrorMessage, 1; 
	END Catch;

	SET @MinID = @MinID + 1

	END
	END

	COMMIT;
	END TRY
	BEGIN CATCH
		IF ( @@TRANCOUNT > 0 )
				ROLLBACK TRANSACTION;
				SET @ErrorMessage = 'An error occurred while publishing ' + @TableSchema + 
				'.' + @TableName + ':' + ERROR_MESSAGE();

		THROW 50000, @ErrorMessage, 1
	END CATCH;

	END
GO
