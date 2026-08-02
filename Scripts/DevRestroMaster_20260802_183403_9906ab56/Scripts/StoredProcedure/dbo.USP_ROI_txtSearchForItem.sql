SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--[dbo].[USP_ROI_txtSearchForItem] 'full' ,0
--DROP PROC [dbo].[USP_ROI_txtSearchForItem] 
CREATE PROCEDURE [dbo].[USP_ROI_txtSearchForItem] 
@ItemName NVARCHAR(256)
,@LanguageID INT
AS
BEGIN
	SELECT rim.ITID AS ItemId
		,rim.ITName AS ItemName
		,rim.PITId AS PItemId
		,rid.ROrderLevel AS LEVEL
		,rid.ImagePath
		,rim.IsCategory
		,itR.SRate
		,coalesce(gm.[Text],rim.ITName) AS LanguageMenuText
	FROM dbo.ROI_ItemDetails rid
	LEFT JOIN dbo.ROI_ITEMMain rim ON rid.ITId = rim.ITId
 inner join ROI_ITEMMain cat on rim.PITId=cat.ITId
	LEFT JOIN ROI_ItemRate itR ON itR.ItemID = rim.ITId
	LEFT JOIN RO_GlobalizedMenu gm on rim.ITId = gm.ItemID 
	and LanguageID=@LanguageID
	--left join dbo.RO_Order_Detail rod on rim.ITId=rod.ItemId  
	WHERE rim.ITName = @ItemName
		AND rim.IsArchived <> 1
		and rim.IsMenu = 1
 and cat.IsArchived=0
 and cat.IsActive=1 and cat.IsMenu=1
END




GO
