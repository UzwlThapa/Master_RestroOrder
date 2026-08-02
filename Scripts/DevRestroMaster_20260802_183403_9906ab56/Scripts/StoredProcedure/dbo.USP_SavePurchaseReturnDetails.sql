SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--DROP PROCEDURE [dbo].[USP_SavePurchaseReturnDetails]
CREATE PROCEDURE [dbo].[USP_SavePurchaseReturnDetails]
@PurchaseReturnId int,
@GDId int,
@STId int,
@ItemID decimal(18,2),
@Qnty decimal(18,2),
@UsedUnitID decimal(18,2),
@Rate decimal(10,2),
@Total decimal(10,2)
as
begin
	INSERT INTO RO_PurchaseReturnDetails(PurchaseReturnId, GDId, STId, ItemID, Qnty, UsedUnitID, Rate, Total) 
	VALUES (@PurchaseReturnId, @GDId, @STId, @ItemID, @Qnty, @UsedUnitID, @Rate, @Total)

	DECLARE @LastItemBalance DECIMAL(18,2)

    -- Get the last ItemBalance from the ROI_StockTransactionMaster table
    SELECT TOP 1 @LastItemBalance = ItemBalance 
    FROM ROI_StockTransactionMaster  where ROI_StockTransactionMaster.ItemId = @ItemID
    ORDER BY TransactionDate DESC

	DECLARE  @LastItemValue DECIMAL(18,2)
	SELECT TOP 1 @LastItemValue = ItemValue 
    FROM ROI_StockTransactionMaster  where ROI_StockTransactionMaster.ItemId = @ItemID
    ORDER BY TransactionDate DESC

	Insert into ROI_StockTransactionMaster(PurchaseReturnTranId, StoreId, ItemId, AvailableQty, Rate, ItemBalance, ItemBalUnitId, ItemValue, TransactionDate) 
	VALUES(@PurchaseReturnId, @STId, @ItemID, @Qnty, @Rate, @LastItemBalance - @Qnty, @UsedUnitID,@LastItemValue- @Total, GETDATE())
END

/*
select * from ROI_StockTransactionMaster

*/
GO
