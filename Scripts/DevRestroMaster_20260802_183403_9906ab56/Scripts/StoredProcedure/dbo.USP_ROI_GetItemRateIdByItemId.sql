SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_ROI_GetItemRateIdByItemId]
@ItemID int
as
select top(1) ItemRateID from ROI_ItemRate where ItemID =@ItemID 






GO
