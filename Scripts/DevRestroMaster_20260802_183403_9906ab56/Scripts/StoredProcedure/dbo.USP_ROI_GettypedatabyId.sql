SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_ROI_GettypedatabyId]
@TypeId int
as
select * from Ro_AdjustmentType where AdjustmentTypeID=@TypeId



GO
