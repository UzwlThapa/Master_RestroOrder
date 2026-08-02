SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_ROI_GETITEMIDPOIDBYNAME]
@ItemName nvarchar(250)
AS
BEGIN



select ITId,
	PurchaseDetailsID,
	ITName,
	UnitId,
	UnitName
 from dbo.ROI_PurchaseDetails p
join dbo.ROI_ITEMMain i on p.ItemID = i.itid
join ROI_Unit3 u on u.UnitId = p.UsedUnitID where ITName=@ItemName
end




GO
