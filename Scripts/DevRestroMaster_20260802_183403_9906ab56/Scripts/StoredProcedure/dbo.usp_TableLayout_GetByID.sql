SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_TableLayout_GetByID] @id int AS SELECT id,name,PortalID,UserModuleID,Culture from TableLayout WHERE id= @id



GO
