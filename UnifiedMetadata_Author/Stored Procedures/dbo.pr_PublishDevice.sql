SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[pr_PublishDevice] @DeviceID INT
AS 
BEGIN

DECLARE @ErrorMessage VARCHAR(max);
BEGIN TRY
BEGIN TRAN;

--Devices
SET IDENTITY_INSERT UnifiedMetadata.ld.Devices ON;
WITH Source AS (
SELECT  DeviceId ,
        DeviceManufacturerId ,
        DeviceTypeId ,
        DeviceSubtypeId ,
        DeviceName ,
        DeviceModelNumber ,
        UpdatedBy ,
        StartDate ,
        EndDate ,
        CreatedDate ,
        UpdatedDate ,
        DevicePublishedId
FROM    UnifiedMetadata_Author.ld.Devices
WHERE   DeviceId = @DeviceID
)
MERGE INTO UnifiedMetadata.ld.Devices WITH(TABLOCK) AS T
USING Source AS S ON S.DeviceId = T.DeviceId

WHEN MATCHED AND NOT EXISTS 
(SELECT S.DeviceManufacturerId ,
        S.DeviceTypeId ,
        S.DeviceSubtypeId ,
        S.DeviceName ,
        S.DeviceModelNumber ,
        S.UpdatedBy ,
        S.StartDate ,
        S.EndDate ,
        S.CreatedDate ,
        S.UpdatedDate ,
        S.DevicePublishedId
		INTERSECT 
SELECT  T.DeviceManufacturerId ,
        T.DeviceTypeId ,
        T.DeviceSubtypeId ,
        T.DeviceName ,
        T.DeviceModelNumber ,
        T.UpdatedBy ,
        T.StartDate ,
        T.EndDate ,
        T.CreatedDate ,
        T.UpdatedDate ,
        T.DevicePublishedId)
THEN UPDATE SET 
         DeviceManufacturerId = S.DeviceManufacturerId
        ,DeviceTypeId 		  = S.DeviceTypeId
        ,DeviceSubtypeId 	  = S.DeviceSubtypeId
        ,DeviceName 		  = S.DeviceName
        ,DeviceModelNumber 	  = S.DeviceModelNumber
        ,UpdatedBy 			  = S.UpdatedBy
        ,StartDate 			  = S.StartDate
        ,EndDate 			  = S.EndDate
        ,CreatedDate 		  = S.CreatedDate
        ,UpdatedDate 		  = S.UpdatedDate
        ,DevicePublishedId	  = S.DevicePublishedId
WHEN NOT MATCHED BY TARGET 
THEN INSERT
(	    DeviceId ,
        DeviceManufacturerId ,
        DeviceTypeId ,
        DeviceSubtypeId ,
        DeviceName ,
        DeviceModelNumber ,
        UpdatedBy ,
        StartDate ,
        EndDate ,
        CreatedDate ,
        UpdatedDate ,
        DevicePublishedId 
		) VALUES (
		DeviceId ,
        DeviceManufacturerId ,
        DeviceTypeId ,
        DeviceSubtypeId ,
        DeviceName ,
        DeviceModelNumber ,
        UpdatedBy ,
        StartDate ,
        EndDate ,
        CreatedDate ,
        UpdatedDate ,
        DevicePublishedId);
SET IDENTITY_INSERT UnifiedMetadata.ld.Devices OFF;


--ValueSetMembers:
SET IDENTITY_INSERT UnifiedMetadata.cdd.ValueSetMembers ON;
WITH Source AS 
(
SELECT  vsm.ValueSetMemberId ,
        vsm.ValueSetId ,
        vsm.DisplayOrder ,
        vsm.UpdatedBy ,
        vsm.CreatedDate ,
        vsm.UpdatedDate ,
        vsm.ValueSetMemberLabel ,
        vsm.StartDate ,
        vsm.EndDate
FROM    UnifiedMetadata_Author.cdd.ValueSetMembers vsm
        INNER JOIN cdd.ValueSetDeviceMembers vsdm ON vsdm.ValueSetMemberId = vsm.ValueSetMemberId
WHERE   vsdm.DeviceId IN ( @DeviceID )
)
MERGE INTO UnifiedMetadata.cdd.ValueSetMembers WITH(TABLOCK) AS T
USING Source AS S ON S.ValueSetMemberId = T.ValueSetMemberId

WHEN MATCHED AND NOT EXISTS 
(SELECT S.ValueSetId ,
        S.DisplayOrder ,
        S.UpdatedBy ,
        S.CreatedDate ,
        S.UpdatedDate ,
        S.ValueSetMemberLabel ,
        S.StartDate ,
        S.EndDate
		INTERSECT
SELECT  T.ValueSetId ,
        T.DisplayOrder ,
        T.UpdatedBy ,
        T.CreatedDate ,
        T.UpdatedDate ,
        T.ValueSetMemberLabel ,
        T.StartDate ,
        T.EndDate
)
THEN UPDATE SET
		 ValueSetId				= S.ValueSetId
        ,DisplayOrder 			= S.DisplayOrder
        ,UpdatedBy 				= S.UpdatedBy
        ,CreatedDate 			= S.CreatedDate
        ,UpdatedDate 			= S.UpdatedDate
        ,ValueSetMemberLabel 	= S.ValueSetMemberLabel
        ,StartDate 				= S.StartDate
        ,EndDate				= S.EndDate

WHEN NOT MATCHED BY TARGET
THEN INSERT
(		ValueSetMemberId ,
        ValueSetId ,
        DisplayOrder ,
        UpdatedBy ,
        CreatedDate ,
        UpdatedDate ,
        ValueSetMemberLabel ,
        StartDate ,
        EndDate
		) VALUES (
		ValueSetMemberId ,
        ValueSetId ,
        DisplayOrder ,
        UpdatedBy ,
        CreatedDate ,
        UpdatedDate ,
        ValueSetMemberLabel ,
        StartDate ,
        EndDate
);
SET IDENTITY_INSERT UnifiedMetadata.cdd.ValueSetMembers OFF;

--RegistryVersions_ValueSetMembers:
SET IDENTITY_INSERT UnifiedMetadata.rdd.RegistryVersions_ValueSetMembers ON;
WITH Source AS (
SELECT  rvvsm.ValueSetMemberId ,
        rvvsm.RegistryVersionId ,
        rvvsm.UpdatedBy ,
        rvvsm.CreatedDate ,
        rvvsm.UpdatedDate ,
        rvvsm.RegistryVersionValueSetMemberId ,
        rvvsm.Label ,
        rvvsm.ConceptDefinitionId
FROM    UnifiedMetadata_Author.cdd.ValueSetMembers vsm
        INNER JOIN cdd.ValueSetDeviceMembers vsdm ON vsdm.ValueSetMemberId = vsm.ValueSetMemberId
        INNER JOIN rdd.RegistryVersions_ValueSetMembers rvvsm ON rvvsm.ValueSetMemberId = vsm.ValueSetMemberId
WHERE   vsdm.DeviceId IN ( @DeviceID )
)
MERGE INTO UnifiedMetadata.rdd.RegistryVersions_ValueSetMembers WITH(TABLOCK) AS T
USING Source AS S ON S.RegistryVersionValueSetMemberId =T.RegistryVersionValueSetMemberId

WHEN MATCHED AND NOT EXISTS
(SELECT S.ValueSetMemberId ,
        S.RegistryVersionId ,
        S.UpdatedBy ,
        S.CreatedDate ,
        S.UpdatedDate ,
        S.Label ,
        S.ConceptDefinitionId
		INTERSECT
SELECT  T.ValueSetMemberId ,
        T.RegistryVersionId ,
        T.UpdatedBy ,
        T.CreatedDate ,
        T.UpdatedDate ,
        T.Label ,
        T.ConceptDefinitionId
)
THEN UPDATE SET
		 ValueSetMemberId		= S.ValueSetMemberId
        ,RegistryVersionId 		= S.RegistryVersionId
        ,UpdatedBy 				= S.UpdatedBy
        ,CreatedDate 			= S.CreatedDate
        ,UpdatedDate 			= S.UpdatedDate
        ,Label 					= S.Label
        ,ConceptDefinitionId	= S.ConceptDefinitionId

WHEN NOT MATCHED BY TARGET
THEN INSERT
(		RegistryVersionValueSetMemberId,
		ValueSetMemberId ,
        RegistryVersionId ,
        UpdatedBy ,
        CreatedDate ,
        UpdatedDate ,
        Label ,
        ConceptDefinitionId
		) VALUES (
		RegistryVersionValueSetMemberId,
		ValueSetMemberId ,
        RegistryVersionId ,
        UpdatedBy ,
        CreatedDate ,
        UpdatedDate ,
        Label ,
        ConceptDefinitionId
);
SET IDENTITY_INSERT UnifiedMetadata.rdd.RegistryVersions_ValueSetMembers OFF;

--ValueSetDeviceMembers:
WITH Source AS (
SELECT  vsdm.ValueSetMemberId ,
        vsdm.DeviceId ,
        vsdm.CreatedDate ,
        vsdm.UpdatedDate
FROM    UnifiedMetadata_Author.cdd.ValueSetMembers vsm
        INNER JOIN cdd.ValueSetDeviceMembers vsdm ON vsdm.ValueSetMemberId = vsm.ValueSetMemberId
WHERE   vsdm.DeviceId IN ( @DeviceID )
)
MERGE INTO UnifiedMetadata.cdd.ValueSetDeviceMembers WITH(TABLOCK) AS T
USING Source AS S ON S.ValueSetMemberId = T.ValueSetMemberId
AND S.DeviceId = T.DeviceId

WHEN MATCHED AND NOT EXISTS 
(SELECT S.CreatedDate,
		S.UpdatedDate
		INTERSECT
SELECT T.CreatedDate,
	   T.UpdatedDate 
)
THEN UPDATE SET
CreatedDate = S.CreatedDate, 
UpdatedDate = S.UpdatedDate 

WHEN NOT MATCHED BY TARGET 
THEN INSERT 
(		ValueSetMemberId ,
        DeviceId ,
        CreatedDate ,
        UpdatedDate
		) VALUES (
		ValueSetMemberId ,
        DeviceId ,
        CreatedDate ,
        UpdatedDate);

COMMIT;
END TRY
BEGIN CATCH
    IF ( @@TRANCOUNT > 0 )
            ROLLBACK TRANSACTION;
    SET @ErrorMessage = 'dbo.pr_PublishDevice:' + ERROR_MESSAGE();
    RAISERROR(@ErrorMessage, 16, 1);
END CATCH;

END
GO
