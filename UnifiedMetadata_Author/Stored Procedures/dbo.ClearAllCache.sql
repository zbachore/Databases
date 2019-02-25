SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author:		sprasad
-- Create date: 04/17/2018
-- Description:	Delete all cache object
-- =============================================
CREATE PROCEDURE [dbo].[ClearAllCache] 

AS
BEGIN

	delete from UnifiedCache.dbo.AuthorCache

END
GO
