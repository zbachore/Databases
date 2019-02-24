SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [dbo].[vConstraintDefinitions] AS 
SELECT dd.ConstraintDefinitions.ConstraintDefinitionId, 
dd.ConstraintDefinitions.ConstraintTypeId, 
dd.ConstraintDefinitions.ConstraintReportingLevelId, 
dd.ConstraintDefinitions.ConstraintDefinitionName, 
dd.ConstraintDefinitions.ConstraintDefinitionDescription, 
dd.ConstraintDefinitions.IntValue, 
dd.ConstraintDefinitions.StringValue, 
dd.ConstraintDefinitions.UpdatedBy, 
dd.ConstraintDefinitions.UnitOfMeasureId, 
dd.ConstraintDefinitions.DecimalValue, 
dd.ConstraintDefinitions.RegistryElementId, 
dd.ConstraintDefinitions.ConstraintDefinitionCode, 
dd.ConstraintDefinitions.ConstraintDefinitionMessage, 
dd.ConstraintDefinitions.Operator, 
CAST([BooleanValue] AS INT) AS BooleanValue, 
dd.ConstraintDefinitions.ConstraintDefinitionScopeId, 
dd.ConstraintDefinitions.CreatedDate, 
dd.ConstraintDefinitions.UpdatedDate, 
dd.ConstraintDefinitions.DateValue, 
CAST([IsNullValue] AS INT) AS IsNullValue, 
CAST([IsQC] AS INT) AS IsQC, 
CAST([IsDQR] AS INT) AS IsDQR, 
CAST([IsCA] AS INT) AS IsCA 
FROM dd.ConstraintDefinitions; 
GO
