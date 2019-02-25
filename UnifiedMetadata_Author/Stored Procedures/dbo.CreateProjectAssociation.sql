SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author:		SPrasad
-- Create date: 11/14/2018
-- Description:	This adds association between project and metadata object
--  exec [dbo].[CreateProjectAssociation] 'dbo.ProjectValueSets', '360','6','sprasad','Added',0,1
-- =============================================
CREATE PROCEDURE [dbo].[CreateProjectAssociation] 
	@tableName varchar(256),
	@referenceId varchar(256),
	@projectId varchar(256),
	@userName varchar(256),
	@action varchar(10),
	@IsRelationShipEntity bit = 0,
	@debug bit =  0
AS
BEGIN

	
	Declare @sqlStr nVarchar(max)	
	if(@IsRelationShipEntity = 0)
	BEGIN
		Set @sqlStr = 'IF NOT EXISTS( SELECT * FROM ' + @tableName +' where ProjectId=' + @projectId + ' and ReferenceId  = ' + @referenceId + ')
					BEGIN
					INSERT INTO '+ @tableName +' 
					(
						ProjectId,
						ReferenceId,
						Action,
						UpdatedBy,
						CreatedDate,
						UpdatedDate
						
					)
					Values
					(
						'+ @projectId + ',
						'+ @referenceId + ',
						'''+ @action + ''',
						'''+ @userName + ''',
						GetDate() ,
						GetDate() 
					)
					END
					ELSE
					BEGIN

					Update ' + @tableName + ' Set Action = ''' + @action + ''' ,UpdatedBy =''' + @userName +''' ,UpdatedDate = GetDate() Where 
					ProjectId=' + @projectId + ' and ReferenceId  = ' + @referenceId + '

					END
					'
	END

	
	if(@debug=1)
		Print (@sqlStr)
	else
		Exec (@sqlStr)

END
GO
