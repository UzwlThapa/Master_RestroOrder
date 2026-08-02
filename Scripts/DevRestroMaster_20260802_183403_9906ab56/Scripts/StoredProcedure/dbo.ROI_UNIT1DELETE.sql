SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ROI_UNIT1DELETE]
@Unit1Id INT
AS
BEGIN
--DELETE FROM ROI_Unit1 WHERE Unit1Id = @Unit1Id
If exists(select * from ROI_ItemDetails where SmallUnit= @Unit1Id and IsArchived=0) 
		SELECT 100
else If exists(select * from ROI_PurchaseDetails where UsedUnitID=@Unit1Id) 
		SELECT 100
else
		update ROI_Unit1 set IsArchived=1, ArchivedOn=GETDATE() where Unit1Id=@Unit1Id
		SELECT 200 
END






GO
