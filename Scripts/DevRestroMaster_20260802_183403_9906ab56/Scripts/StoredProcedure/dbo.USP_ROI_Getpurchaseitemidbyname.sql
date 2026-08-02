SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--[USP_ROI_Getpurchaseitemidbyname] 'Chilly Paneer'

CREATE PROCEDURE [dbo].[USP_ROI_Getpurchaseitemidbyname]
@ITName nvarchar(150)
AS
BEGIN
	SELECT  IM.ITName, PD.PurchaseDetailsID, ItemID
	
	FROM DBO.ROI_PurchaseDetails PD
	INNER JOIN DBO.ROI_ITEMMain IM ON PD.ItemID = IM.ITId where ITName = @ITName
	
END

--SELECT * FROM DBO.ROI_PurchaseDetails 
--SELECT * FROM DBO.ROI_PurchaseDetails
--update DBO.ROI_PurchaseDetails set ItemID=2 where PurchaseDetailsID=8




GO
