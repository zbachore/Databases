SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

Create Function [dbo].[fn_getParentStringValue](@stringValue as varchar(4000))
Returns varchar(4000)
AS
BEGIN
--declare @stringValue as varchar(255)
--set @stringValue = 'a,b,c'
declare  @parentValue table(Name varchar(255))
declare  @result varchar(4000)
INSERT INTO @parentValue
	SELECT c.ConceptName 
	FROM cdd.ValueSetMembers vsm 
	inner join cdd.ValueSetConceptMembers vscm on vsm.ValueSetMemberId = vscm.ValueSetMemberId 
	inner join cdd.Concepts c on vscm.ConceptId = c.ConceptId 
	Where vsm.ValueSetId in (
				select x.i.value('.','varchar(3)')
				from (select XMLList=cast('<i>'+replace(@stringValue,',','</i><i>')+'</i>' as xml)) a
				cross apply XMLList.nodes('i') x(i)
				)

Set @result = (select stuff((select ','+convert(varchar(100),Name) from @parentValue for xml path('')),1,1,''))
RETURN @result
End
GO
