SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[USP_RO_GETORDERMASTERFORSPLIT]
(
@TableId nvarchar(50),
@SeatNo int
)
AS
BEGIN
	declare @val varchar(90)
	if(@SeatNo = 0)
	begin
	
		set @val= dbo.fn_getMaxMasterId(@TableId)
			select * FROM dbo.RO_OrderMasters join  dbo.RO_Order_Detail on RO_Order_Detail.OrderMasterId = dbo.RO_OrderMasters.OrderMasterID join ROI_ITEMMain on ROI_ITEMMain.ITId =  RO_Order_Detail.ItemId full join RO_CompanyInfo on RO_CompanyInfo.ID=1
	  WHERE dbo.RO_OrderMasters.TableId = @TableId and dbo.RO_OrderMasters.OrderMasterID=@val and RO_OrderMasters.IsCancelled = 0 and RO_OrderMasters.BillPaid =0
		--select * FROM dbo.RO_OrderMasters join  dbo.RO_Order_Detail on RO_Order_Detail.OrderMasterId = dbo.RO_OrderMasters.OrderMasterID join RO_Items on RO_Items.ItemID =  RO_Order_Detail.ItemId full join RO_CompanyInfo on RO_CompanyInfo.ID=1
	 -- WHERE dbo.RO_OrderMasters.TableId = @TableId and dbo.RO_OrderMasters.OrderMasterID=@val and RO_OrderMasters.IsCancelled = 0 and RO_OrderMasters.BillPaid =0
	end
	else
	begin	
	--declare @val varchar(90)
	set @val= dbo.fn_getMaxMasterId(@TableId)
	select * FROM  dbo.RO_Order_Detail join dbo.RO_OrderMasters on RO_Order_Detail.OrderMasterId = dbo.RO_OrderMasters.OrderMasterID join ROI_ITEMMain on ROI_ITEMMain.ITId =  RO_Order_Detail.ItemId
	WHERE dbo.RO_OrderMasters.TableId = @TableId and dbo.RO_OrderMasters.OrderMasterID=@val and RO_OrderMasters.IsCancelled = 0 and RO_Order_Detail.SeatNo=@SeatNo and RO_OrderMasters.BillPaid =0
	end
	
end





GO
