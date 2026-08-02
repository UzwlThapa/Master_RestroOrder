SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_ROI_EditAdjustmentType]
@TypeId int ,
@AdjustmentTypeName nvarchar(max),
@IsActive int,
@Username nvarchar(max)
as
update Ro_AdjustmentType
 set 
 AdjustmentTypeName=@AdjustmentTypeName
,IsActive=@IsActive
,UpdatedBy=@Username
,UpdatedOn=GETDATE()

where AdjustmentTypeID = @TypeId



GO
