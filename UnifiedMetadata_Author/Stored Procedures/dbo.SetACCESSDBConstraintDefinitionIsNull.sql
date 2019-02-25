SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SetACCESSDBConstraintDefinitionIsNull]  
       @ConstraintDefinitionId INT   
AS
  -- Temporary procedure used by ACCESS CDD Tool to set a table column to NULL value since ACCESS does not support setting boolean column to null
BEGIN  
       UPDATE  [dd].[ConstraintDefinitions]
       SET IsNullValue = NULL
       WHERE  ConstraintDefinitionId = @ConstraintDefinitionId
END
GO
