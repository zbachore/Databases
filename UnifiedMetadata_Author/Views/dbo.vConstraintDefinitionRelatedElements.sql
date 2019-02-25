SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


Create View [dbo].[vConstraintDefinitionRelatedElements] As 
SELECT [ConstraintDefinitionRelatedElementId]
      ,[ConstraintDefinitionId]
      ,[RegistryElementId]
      ,[IntValue]
      ,[DecimalValue]
      ,Cast([IsNullValue] As int) As [IsNullValue]
      ,[CreatedDate]
      ,[UpdatedDate]
      ,[UpdatedBy]
      ,[Operator]
      ,[StringValue]
      ,[DisplayOrder]
  FROM [dd].[ConstraintDefinitionRelatedElements]
GO
