SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


-- ==========================================================
-- Author: Ganesan Muthiah
-- Create date: September 24 2016
-- Description: Updates ICD Device.
-- 5/26/2017 -- smott-- Updated to changes that were only made in stgdb2
-- 07/08/2017 --zbachore modified this stored procedure to handle the removal of tables' identity properties
-- ==========================================================
CREATE PROCEDURE [dbo].[pr_Update_Unified_ICD_Device]
	  @DeviceId INT,
	  @DeviceManufacturerId INT,
	  @DeviceTypeId INT,
	  @DeviceSubtypeId INT,
	  @DeviceName NVARCHAR(255),
	  @DeviceModelNumber NVARCHAR(100),
	  @UpdatedBy NVARCHAR(100),
	  @StartDate DATETIME,
	  @EndDate DATETIME,
	  @DevicePublishedId INT,
	  @ValueSetId INT,
	  @ValueSetMemberLabel NVARCHAR(255),
	  @RegistryVersionID INT
AS
	  BEGIN
			SET NOCOUNT ON;
			DECLARE	@ValueSetMemberId INT; 
			DECLARE @NewDeviceID int = (SELECT MAX(DeviceID) + 1 FROM ld.Devices)
			DECLARE @NewValueSetMemberID int = (SELECT MAX(ValueSetMemberID) + 1 FROM cdd.ValueSetMembers)
			DECLARE @RegistryVersionValueSetMemberId int = (SELECT MAX(RegistryVersionValueSetMemberId) + 1 
			FROM rdd.RegistryVersions_ValueSetMembers)

			IF @DeviceId IS NULL OR @DeviceId=0
			   BEGIN
					 PRINT 'INSERT';
					 IF @DeviceId=0 
						SET @DeviceID=NULL
					 
					 
					   ------SELECT devicename,DevicePublishedId,COUNT(*) FROM		[ld].[Devices]
					   ------GROUP BY devicename,DevicePublishedId
					   ------HAVING COUNT(*)>1

					 SELECT	@DeviceId = DeviceId
					 FROM	[ld].[Devices]
					 WHERE	DeviceName = @DeviceName
							AND DevicePublishedId = @DevicePublishedId;
					-- We are checking this again from the table , so for explant kind of things we don't insert again.
					 PRINT 'DeviceId is ' + CAST(@DeviceId AS VARCHAR(5));

					 IF @DeviceId IS NULL
						BEGIN
						 PRINT  'INSERT new device'
						 SELECT @DeviceID = @NewDeviceID;
						 --SET IDENTITY_INSERT ld.Devices ON;
							  INSERT	INTO [ld].[Devices]
										(
										 [DeviceManufacturerId],
										 [DeviceTypeId],
										 [DeviceSubtypeId],
										 [DeviceName],
										 [DeviceModelNumber],
										 [UpdatedBy],
										 [StartDate],
										 [EndDate],
										 [CreatedDate],
										 [UpdatedDate],
										 [DevicePublishedId]
								
										)
							  VALUES	(
										 @DeviceManufacturerId,
										 @DeviceTypeId,
										 @DeviceSubtypeId,
										 @DeviceName,
										 @DeviceModelNumber,
										 @UpdatedBy,
										 @StartDate,
										 @EndDate,
										 GETDATE(),
										 GETDATE(),
										 @DevicePublishedId
										)
								--SET IDENTITY_INSERT ld.Devices OFF;
				
							  SET @DeviceId = SCOPE_IDENTITY(); --changed this
							  --SELECT @DeviceId = MAX(DeviceID) FROM ld.Devices --to this
						END;
					 
					 PRINT 'DeviceId is ' + CAST(@DeviceId AS VARCHAR(5));
					 SELECT @ValueSetMemberId = @NewValueSetMemberID;

					IF NOT EXISTS(
					SELECT vsm.ValueSetMemberID
					FROM cdd.ValueSetMembers vsm
					INNER JOIN cdd.ValueSetDeviceMembers vsdm ON vsdm.ValueSetMemberId = vsm.ValueSetMemberId
					WHERE vsdm.DeviceId = @DeviceID
					)
					 BEGIN

					 --SET IDENTITY_INSERT cdd.ValueSetMembers ON;
					 INSERT	INTO cdd.ValueSetMembers
							(
							 ValueSetId,
							 DisplayOrder,
							 UpdatedBy,
							 CreatedDate,
							 UpdatedDate,
							 ValueSetMemberLabel,
							 StartDate,
							 EndDate
							)
					 VALUES	(
					         @ValueSetId, -- ValueSetId - int
							 [dbo].[udf_getValueSetDisplayOrder](@ValueSetId),
							 @UpdatedBy, -- UpdatedBy - nvarchar(100)
							 GETDATE(), -- CreatedDate - datetime
							 GETDATE(), -- UpdatedDate - datetime
							 @ValueSetMemberLabel, -- ValueSetMemberLabel - nvarchar(255)
							 @StartDate, -- StartDate - datetime
							 @EndDate  -- EndDate - datetime
							)
						--SET IDENTITY_INSERT cdd.ValueSetMembers OFF;
						END

					 SET @ValueSetMemberId = SCOPE_IDENTITY();
					 --SELECT @ValueSetMemberId = MAX(ValueSetMemberID) FROM cdd.ValueSetMembers --to this

					 PRINT 'ValueSet MemberId is '
						   + CAST(@ValueSetMemberId AS VARCHAR(5));

					 IF NOT EXISTS(
						SELECT  rvvsm.RegistryVersionValueSetMemberId ,
						vsdm.DeviceId
						FROM    cdd.ValueSetMembers vsm
						INNER JOIN cdd.ValueSetDeviceMembers vsdm ON vsdm.ValueSetMemberId = vsm.ValueSetMemberId
						INNER JOIN rdd.RegistryVersions_ValueSetMembers rvvsm ON rvvsm.ValueSetMemberId = vsm.ValueSetMemberId
						WHERE   rvvsm.RegistryVersionId = 3
						AND vsdm.DeviceID = @DeviceID
					 )
					 BEGIN
					 --SET IDENTITY_INSERT rdd.RegistryVersions_ValueSetMembers ON;
					 INSERT	INTO rdd.RegistryVersions_ValueSetMembers
							(
							 ValueSetMemberId,
							 RegistryVersionId,
							 UpdatedBy,
							 CreatedDate,
							 UpdatedDate
							)
					 VALUES	(
							 @ValueSetMemberId, -- ValueSetMemberId - int
							 @RegistryVersionID, -- RegistryVersionId - int
							 @UpdatedBy, -- UpdatedBy - nvarchar(100)
							 GETDATE(), -- CreatedDate - datetime
							 GETDATE()  -- UpdatedDate - datetime
							);
						--SET IDENTITY_INSERT rdd.RegistryVersions_ValueSetMembers OFF;
						END

					--IF NOT EXISTS(SELECT ValueSetMemberID FROM cdd.ValueSetDeviceMembers WHERE ValueSetMemberID = @ValueSetMemberId)
					BEGIN
					 INSERT	INTO cdd.ValueSetDeviceMembers
							(ValueSetMemberId,
							 DeviceId,
							 CreatedDate,
							 UpdatedDate
							)
					 VALUES	(@ValueSetMemberId, -- ValueSetMemberId - int
							 @DeviceId, -- DeviceId - int
							 GETDATE(), -- CreatedDate - datetime
							 GETDATE()  -- UpdatedDate - datetime
							);
						END

					 PRINT 'Completed';
			   END;
			ELSE
			   BEGIN
					 PRINT 'Update';
					 UPDATE	[ld].[Devices]
					 SET	[DeviceManufacturerId] = CASE WHEN [DeviceManufacturerId] IS NOT NULL
														  THEN @DeviceManufacturerId
														  ELSE [DeviceManufacturerId]
													 END,
							[DeviceTypeId] = CASE WHEN [DeviceTypeId] IS NOT NULL
												  THEN @DeviceTypeId
												  ELSE [DeviceTypeId]
											 END,
							[DeviceSubtypeId] = CASE WHEN [DeviceSubtypeId] IS NOT NULL
													 THEN @DeviceSubtypeId
													 ELSE [DeviceSubtypeId]
												END,
							[DeviceName] = CASE	WHEN [DeviceName] IS NOT NULL
												THEN @DeviceName
												ELSE [DeviceName]
										   END,
							[DeviceModelNumber] = CASE WHEN [DeviceModelNumber] IS NOT NULL
													   THEN @DeviceModelNumber
													   ELSE [DeviceModelNumber]
												  END,
							[StartDate] = CASE WHEN [StartDate] IS NOT NULL
											   THEN @StartDate
											   ELSE [StartDate]
										  END,
							[EndDate] = CASE WHEN [EndDate] IS NOT NULL
											 THEN @EndDate
											 ELSE [EndDate]
										END,
							[UpdatedBy] = @UpdatedBy,
							[UpdatedDate] = GETDATE()
					 WHERE	DeviceId = @DeviceId;

			   END;

	  END;

           


GO
