SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create View [dbo].[vUnitOfMeasures]
AS
select UnitOfMeasureId,UnitOfMeasureName ,ConceptID  from cdd.UnitsOfMeasure 
Union
Select a.UnitOfMeasureId,a.UnitOfMeasureAliasName ,u.ConceptID 
from cdd.UnitsOfMeasureAlias a 
Join cdd.UnitsOfMeasure u  on a.UnitOfMeasureId =  u.UnitOfMeasureId 
GO
