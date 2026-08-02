SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- [dbo].[USP_RO_GETORDERMASTER] 1
CREATE PROCEDURE [dbo].[USP_RO_GETORDERMASTER] 
(
@TableId nvarchar(50)
)
AS
BEGIN
	declare @val varchar(90)
	set @val= dbo.fn_getMaxMasterId(@TableId)
		select * FROM dbo.RO_OrderMasters join  dbo.RO_Order_Detail
		 on RO_Order_Detail.OrderMasterId = dbo.RO_OrderMasters.OrderMasterID join ROI_ITEMMain
		  on ROI_ITEMMain.ITId =  RO_Order_Detail.ROI_ItemId full join RO_CompanyInfo on RO_CompanyInfo.ID=1
  WHERE dbo.RO_OrderMasters.TableId = @TableId and dbo.RO_OrderMasters.OrderMasterID=@val 
  and RO_OrderMasters.IsCancelled = 0 and RO_OrderMasters.BillPaid = 0
  and RO_Order_Detail.IsCancelled=0
end



GO
