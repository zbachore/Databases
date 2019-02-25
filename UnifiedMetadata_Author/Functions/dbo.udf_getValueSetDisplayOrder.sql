SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE  FUNCTION [dbo].[udf_getValueSetDisplayOrder](@ValueSetID INT) RETURNS INT 
AS 
BEGIN
		-- =============================================
		-- Author:		Ganesan Muthiah
		-- Create date: 10/20/2016
		-- Description:	Function returns the maximum display order for the particular valueset
		-- =============================================
		DECLARE @DisplayOrder int
		
		SELECT @DisplayOrder=MAX(DisplayOrder) +1 FROM cdd.ValueSetMembers WHERE ValueSetId IN (@ValueSetID)
							GROUP BY ValueSetId 
				
		RETURN @DisplayOrder
END
GO
