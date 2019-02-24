SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[pr_AssociateDynamicListToProject] @ProjectID int
AS 
BEGIN
/**************************************************************************************************
Project:		UMTS Metadata Tool
JIRA:			[Ticket # here]
Developer:		zbachore
Date:			2018-09-14
Description:	This procedure is intended to eliminate the manual publishing of
				all unpublished DynamicLists when publishing to the EDW servers.
				Helps to avoid job failures due to unpublished dynamic lists.
___________________________________________________________________________________________________
Example: 
EXEC dbo.pr_AssociateDynamicListToProject 6 

___________________________________________________________________________________________________
Revision History
Date			Author			Reason for Change

-------	 ------- -----------------------------------------------------------------------
***************************************************************************************************/
DECLARE @ErrorMessage VARCHAR(max) = 'An error occurred in procedure: ',
		@Procedure VARCHAR(MAX) =   OBJECT_NAME(@@PROCID),
		@RegistryVersionID INT,
		@ServerName VARCHAR(MAX) = @@SERVERNAME,
		@RequestedTime DATETIME2, --testing, remove later.
		@PvsID INT = (SELECT MAX(ID) FROM dbo.ProjectValueSets),
		@PvsMembersID INT = (SELECT MAX(ID) FROM dbo.ProjectValueSetMembers),
		@ProjectName VARCHAR(MAX)


BEGIN TRY
BEGIN TRAN;

--Only do this for dev and staging servers.
--Production publishing should go through 
--the regular deployment process.
IF 
	@@SERVERNAME = 'DEVNCDREDWDB1' OR 
	@@SERVERNAME = 'STGNCDREDWDB1' OR 
	@@SERVERNAME = 'STGNCDRICDDB1\EDW' OR
	@@SERVERNAME = 'DEVNCDRTRNDB1'
BEGIN

SELECT 
	@RegistryVersionID = RegistryVersionId,
	@ProjectID = @ProjectID,
	@ProjectName = ProjectName
FROM dbo.Project 
WHERE RegistryVersionId = @RegistryVersionID;

--SELECT @RegistryVersionID, @ProjectID, @ProjectName;



--Now, using @RegistryVersionID, identify all Published ValueSets after the last successful publish
--for this RegistryVersionID
--Identify the last successful publish date:

--this is to insert to ProjectValueSets

WITH ValueSets AS 
(
SELECT DISTINCT 
	ProjectId = @ProjectID,
	ProjectName = @ProjectName,
	vs.ValueSetID, 
	UpdatedBy = SUSER_NAME(),
	IsModified = 1
FROM cdd.ValueSets vs
INNER JOIN dbo.PublishQueue pq 
	ON pq.ValueSetID = vs.ValueSetId
INNER JOIN cdd.ValueSetMembers vsm 
	ON vsm.ValueSetId = vs.ValueSetId
INNER JOIN rdd.RegistryVersions_ValueSetMembers rvvsm
	ON rvvsm.ValueSetMemberId = vsm.ValueSetMemberId
	WHERE pq.RegistryVersionID = rvvsm.RegistryVersionId
	AND pq.RegistryVersionID = @RegistryVersionID--for the currently publishing project.
	)
	INSERT INTO dbo.ProjectValueSets
(
    Id,
    ProjectId,
    ProjectName,
    ValueSetId,
    UpdatedBy,
    IsModified
)
SELECT --Check if this ValueSetID is actually used. We don't want to insert
		--something that is not actually used.
	ID = @PvsID + ROW_NUMBER() OVER( ORDER BY (SELECT NULL)),
    vs.ProjectId,
    vs.ProjectName,
    vs.ValueSetId,
    vs.UpdatedBy,
    vs.IsModified
FROM ValueSets vs 
WHERE ValueSetID NOT IN (	SELECT ValueSetID 
							FROM dbo.ProjectValueSets 
							WHERE ProjectID = @ProjectID);


--Insert to ProjectValueSetMembers
WITH ValueSetMembers AS(
SELECT DISTINCT 
	ProjectId = @ProjectID,
	ProjectName = @ProjectName,
	vsm.ValueSetMemberID, 
	UpdatedBy = SUSER_NAME()
FROM cdd.ValueSets vs
INNER JOIN dbo.PublishQueue pq 
	ON vs.ValueSetID = pq.ValueSetID 
	INNER JOIN cdd.ValueSetMembers vsm 
	ON vs.ValueSetID = vsm.ValueSetID
INNER JOIN rdd.RegistryVersions_ValueSetMembers rvvsm 
	ON rvvsm.ValueSetMemberId = vsm.ValueSetMemberId
	WHERE pq.RegistryVersionID = rvvsm.RegistryVersionId
	AND pq.RegistryVersionID = @RegistryVersionID
) 
INSERT INTO dbo.ProjectValueSetMembers
(
    Id,
    ProjectId,
    ProjectName,
    ValueSetMemberId,
    UpdatedBy
)

SELECT
    ID = @PvsMembersID + ROW_NUMBER() OVER( ORDER BY (SELECT NULL)),
    ProjectId = @ProjectID,
    ProjectName = @ProjectName,
    vsm.ValueSetMemberId,
    vsm.UpdatedBy
FROM ValueSetMembers vsm 
WHERE ValueSetMemberID NOT IN (SELECT ValueSetMemberId 
FROM dbo.ProjectValueSetMembers WHERE ProjectID = @ProjectID)
	
    
END

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
