SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_ROI_DeleteAdjustmentType]
@id int,
@Username nvarchar(256)
as

update Ro_AdjustmentType set IsDeleted=1,DeletedBy=@Username,DeletedOn=GETDATE() where AdjustmentTypeID=@id 



GO
