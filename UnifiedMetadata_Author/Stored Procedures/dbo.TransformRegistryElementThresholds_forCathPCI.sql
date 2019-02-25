SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[TransformRegistryElementThresholds_forCathPCI]
--WITH EXECUTE AS CALLER
AS
BEGIN
SET NOCOUNT ON;
SET XACT_ABORT ON;

/**************************************************************************************************
Project:		EDW2.0
JIRA:			?
Developer:		zbachore
Date:			2016-05-26
Description:	
___________________________________________________________________________________________________
Example: Exec dbo.TransformRegistryElementThresholds @RegistryVersionID int
select * from UnifiedMetadata.rdd.RegistryElementThresholds where RegistryVersionID = 3
select * from UnifiedMetadata.rdd.RegistryElementThresholds where RegistryVersionID = 6
___________________________________________________________________________________________________
Revision History
Date			Author			Reason for Change

TRUNCATE TABLE dbo.RegistryElementThresholds
-------	 ------- -----------------------------------------------------------------------
***************************************************************************************************/
--Variables:
DECLARE @StartTime DATETIME2(3) = SYSDATETIME(),
		@ErrorMessage varchar(2000) = ' '

BEGIN TRY
;WITH Source AS (
SELECT 
			--T.RegistryElementThresholdId
            RegistryElementId
           ,Threshold
           ,CompositeId
		   ,DataElementSeq
           ,StartDate
           ,EndDate = '2999-12-31 00:00:00.000'
           ,RegistryVersionId
           ,UpdatedBy = 'Emilia'
           ,CreatedDate
           ,UpdatedDate
           ,FormSectionId
           ,FormPageId
		  
FROM  [ACC-INFO\jerkus].[tmpThresholdsMetadata_Cath] 
)

MERGE INTO  [rdd].[RegistryElementThresholds_20170925] WITH (TABLOCK) AS T
USING Source AS S ON S.RegistryElementId = T.[RegistryElementId]
                  AND S.CompositeId = T.CompositeId
				  AND s.RegistryVersionID = 6

WHEN MATCHED AND NOT EXISTS

(SELECT		S.RegistryElementId
           ,S.Threshold
           ,S.CompositeId
           ,S.StartDate
           ,S.EndDate
           ,S.RegistryVersionId
           ,S.UpdatedBy
           ,S.CreatedDate
           ,S.FormSectionId
           ,S.FormPageId
		   
		   INTERSECT

SELECT		T.RegistryElementId
           ,T.Threshold
           ,T.CompositeId
           ,T.StartDate
           ,T.EndDate
           ,T.RegistryVersionId
           ,T.UpdatedBy
           ,T.CreatedDate
           ,T.FormSectionId
           ,T.FormPageId
		   )

	THEN UPDATE SET
			RegistryElementID	=		S.RegistryElementId
           ,Threshold			=		S.Threshold
           ,CompositeId			=		S.CompositeId
           ,StartDate			=		S.StartDate
           ,EndDate				=		S.EndDate
           ,RegistryVersionID	=		S.RegistryVersionId
           ,UpdatedBy			=		S.UpdatedBy
           ,CreatedDate			=		S.CreatedDate
           ,UpdatedDate			=		GETDATE()
           ,FormSectionID		=		S.FormSectionId
           ,FormPageID			=		S.FormPageId

--WHEN NOT MATCHED BY SOURCE
--THEN DELETE


WHEN NOT MATCHED BY TARGET
THEN INSERT
           ([RegistryElementId]
           ,[Threshold]
           ,[CompositeId]
           ,[StartDate]
           ,[EndDate]
           ,[RegistryVersionId]
           ,[UpdatedBy]
           ,[CreatedDate]
           ,[FormSectionId]
           ,[FormPageId]
		   ,UpdatedDate
		   ) VALUES
		   ([RegistryElementId]
           ,[Threshold]
           ,[CompositeId]
           ,[StartDate]
           ,[EndDate]
           ,[RegistryVersionId]
           ,[UpdatedBy]
           ,[CreatedDate]
           ,[FormSectionId]
           ,[FormPageId]
		   ,GETDATE()
		   );

END TRY
BEGIN CATCH
	set @ErrorMessage =  'An error occurred in stored procedure dbo.RegistryElementThresholds: '+error_message()
	RAISERROR (@ErrorMessage, 16, 1 );
	RETURN -1;
END CATCH
END



GO
