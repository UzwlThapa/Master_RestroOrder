SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_ROI_SaveAdjustmentType]
@AdjustmentTypeName nvarchar(max),
@IsActive bit,
@AddedBy nvarchar(max)
AS
INSERT INTO Ro_AdjustmentType(AdjustmentTypeName,IsActive,AddedBy,AddedOn)
VALUES (@AdjustmentTypeName,@IsActive,@AddedBy,GETDATE());



GO
