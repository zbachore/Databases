SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [ld].[pr_LoadFacilities] 
AS 
BEGIN
/**************************************************************************************************
Project:		UMTS Metadata Tool
JIRA:			?
Developer:		zbachore
Date:			Jan 11 2018  8:24PM
Description:	This procedure loads data from ld.facilities in stage to ld.Facilities in 
				UnifiedMetadata.
___________________________________________________________________________________________________
Example:		EXEC ld.pr_LoadFacilities
___________________________________________________________________________________________________
Revision History
Date			Author			Reason for Change
2018-03-08		zbachore		Modified to update only rows that are different
-------	 ------- -----------------------------------------------------------------------
***************************************************************************************************/
DECLARE @ErrorMessage VARCHAR(max)

BEGIN TRY
BEGIN TRAN;

WITH Source AS (
SELECT S.FacilityID,
		s.AHANumber,
       s.FacilityName,
       s.FacilityAddress,
       s.FacilityState,
       s.FacilityCity,
       s.FacilityZipCode,
       CreatedBy = SUSER_NAME(),
       UpdatedBy = SUSER_NAME(),
       Active = 1,
       CreatedById = SUSER_ID(),
       UpdatedById = SUSER_ID()
FROM UnifiedMetadata_Stage.ld.Facilities s
)

MERGE INTO UnifiedMetadata.ld.Facilities AS T 
USING Source AS S ON S.AHANumber = T.AHANumber

WHEN MATCHED AND NOT EXISTS 
(SELECT s.FacilityID,
		s.FacilityName,
        s.FacilityAddress,
        s.FacilityState,
        s.FacilityCity,
        s.FacilityZipCode,
        s.CreatedBy,
        s.UpdatedBy,
        s.Active,
        s.CreatedById,
        s.UpdatedById
		INTERSECT
SELECT  T.FacilityID,
		T.FacilityName,
        T.FacilityAddress,
        T.FacilityState,
        T.FacilityCity,
        T.FacilityZipCode,
        T.CreatedBy,
        T.UpdatedBy,
        T.Active,
        T.CreatedById,
        T.UpdatedById
		)
THEN UPDATE SET 
		FacilityID		=	S.FacilityID,
		FacilityName	=	S.FacilityName,
        FacilityAddress =	S.FacilityAddress,
        FacilityState	=	S.FacilityState,
        FacilityCity	=	S.FacilityCity,
        FacilityZipCode =	S.FacilityZipCode,
        CreatedBy		=	S.CreatedBy,
        UpdatedBy		=	S.UpdatedBy,
        Active			=	S.Active,
        CreatedByID		=	S.CreatedById,
        UpdatedByID		=	S.UpdatedById,
		UpdatedDate		=	DEFAULT

WHEN NOT MATCHED BY SOURCE 
AND T.Active = 1
THEN UPDATE SET 
Active = 0

WHEN NOT MATCHED BY TARGET 
THEN INSERT
(		FacilityID, 
		AHANumber,
		FacilityName,
        FacilityAddress,
        FacilityState,
        FacilityCity,
        FacilityZipCode,
        CreatedBy,
        UpdatedBy,
        Active,
        CreatedById,
        UpdatedById
		) VALUES (
		FacilityID,
		AHANumber,
		FacilityName,
        FacilityAddress,
        FacilityState,
        FacilityCity,
        FacilityZipCode,
        CreatedBy,
        UpdatedBy,
        Active,
        CreatedById,
        UpdatedById
		);

UPDATE rf 
SET Active = f.Active
FROM UnifiedMetadata.ld.Facilities f
LEFT JOIN UnifiedMetadata.ld.RegistryFacilities rf ON f.FacilityID = rf.FacilityID 
WHERE f.Active = 0 
AND rf.Active = 1	

COMMIT;
END TRY
BEGIN CATCH
    IF ( @@TRANCOUNT > 0 )
            ROLLBACK TRANSACTION;
    SET @ErrorMessage = 'ld.pr_LoadFacilities:' + ERROR_MESSAGE();
    THROW 50000, @ErrorMessage, 1
END CATCH;

END
GO
