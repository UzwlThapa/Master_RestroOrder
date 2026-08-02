SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_RO_GETWORD]
(
@Amount decimal(12,2),
@BigCurrency varchar(50),
@SmallCurrency varchar(50)
)
AS
BEGIN
	Select dbo.[fNumToWords](@Amount, @BigCurrency, @SmallCurrency) as InWords
	--select * FROM dbo.RO_OrderMasters join  dbo.RO_Order_Detail on RO_Order_Detail.OrderMasterId = dbo.RO_OrderMasters.OrderMasterID join RO_Items on RO_Items.ItemID =  RO_Order_Detail.ItemId full join RO_CompanyInfo on RO_CompanyInfo.ID=1
  ----WHERE dbo.RO_OrderMasters.TableId = @TableId and dbo.RO_OrderMasters.OrderMasterID=@val and RO_OrderMasters.IsCancelled = 0
end


--print dbo.[fNumToWords](100.10,'Rupees', 'Paisa') 




GO
