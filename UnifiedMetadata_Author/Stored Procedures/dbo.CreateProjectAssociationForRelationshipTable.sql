SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


-- =============================================
-- Author:		SPrasad
-- Create date: 11/14/2018
-- Description:	This adds association between project and relationship table
--  exec [dbo].[CreateProjectAssociationForRelationshipTable]  'dbo.ProjectValueSetsTaxonomy', '243','-1','ValueSetId','TaxonId','cdd.ValueSets_Taxonomy','ValueSetsTaxonomyID',4,'Sanjit Prasad','Inserted',null,1
-- =============================================
CREATE PROCEDURE [dbo].[CreateProjectAssociationForRelationshipTable] 
	@tableName varchar(256),
	@leftReferenceId varchar(256),
	@rightReferenceId varchar(256),
	@leftReferenceName  varchar(256),
	@rightReferenceName  varchar(256),
	@relationshipTable  varchar(256),
	@relatioshipKeyName varchar(256),
	@projectId varchar(256),
	@userName varchar(256),
	@action varchar(10),
	@deletedRelationshipReferenceId varchar(256),
	@debug bit =  0
AS
BEGIN

	Declare @SqlStrAssciation nVarchar(max)
	Declare @sqlStr nVarchar(max)
	Declare @AssociationId varchar(256)	

	--Set @tableName = ''
	--Set @leftReferenceId = '243'
	--Set @rightReferenceId = '-1'
	--Set @leftReferenceName  = 'ValueSetId'
	--Set @rightReferenceName  = 'TaxonId'
	--Set @relationshipTable = 'cdd.ValueSets_Taxonomy'
	--Set @relatioshipKeyName = 'ValueSetsTaxonomyID'
	--Set @projectId = ''
	--Set @userName = ''
	--Set @action = ''
	--Set @debug  =  0
	
	if(@action <> 'Deleted')
	BEGIN
	Set @SqlStrAssciation = 'Select @AssociationId = ' +  @relatioshipKeyName  +' from ' + @relationshipTable +' where ' + @leftReferenceName + ' = '+ @leftReferenceId +' and '+  @rightReferenceName +' = ' + @rightReferenceId
	
	exec sp_executesql @SqlStrAssciation, 
                    N'@AssociationId varchar(256) output', @AssociationId output;
	END
	ELSE 
	BEGIN
		Set @AssociationId = @deletedRelationshipReferenceId
	END

	if(@debug = 1)
	begin
		print(@SqlStrAssciation)
		print('AssociationId = ' + @AssociationId)
	end
	if ISNULL(@AssociationId,0) = 0 
	BEGIN
		PRINT('No Association found.')
		return
	END

	Set @sqlStr = 'IF NOT EXISTS( SELECT * FROM ' + @tableName +' where ProjectId=' + @projectId + ' and ReferenceId  = ' + @AssociationId + ')
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
						'+ @AssociationId + ',
						'''+ @action + ''',
						'''+ @userName + ''',
						GetDate() ,
						GetDate() 
					)
					END
					ELSE
					BEGIN

					Update ' + @tableName + ' Set Action = ''' + @action + ''' ,UpdatedBy =''' + @userName +''' ,UpdatedDate = GetDate() Where 
					ProjectId=' + @projectId + ' and ReferenceId  = ' + @AssociationId + '

					END
					'

	if(@debug=1)
		Print (@sqlStr)
	else
		Exec (@sqlStr)

END


GO
