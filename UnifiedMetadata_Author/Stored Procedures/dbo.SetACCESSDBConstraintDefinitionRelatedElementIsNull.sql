SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[SetACCESSDBConstraintDefinitionRelatedElementIsNull]  
       @ConstraintDefinitionRelatedElementId INT   
AS
  -- Temporary procedure used by ACCESS CDD Tool to set a table column to NULL value since ACCESS does not support setting boolean column to null
BEGIN  
       UPDATE  [dd].[ConstraintDefinitionRelatedElements]
       SET IsNullValue = NULL
       WHERE  ConstraintDefinitionRelatedElementId = @ConstraintDefinitionRelatedElementId;
END
GO
