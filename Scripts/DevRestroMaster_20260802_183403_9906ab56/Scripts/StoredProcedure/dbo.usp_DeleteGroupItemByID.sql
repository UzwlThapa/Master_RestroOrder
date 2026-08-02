SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_DeleteGroupItemByID]
@ids int
as
update Roi_GroupWithItem set IsArchived=1 where GroupID=@ids



GO
