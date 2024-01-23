UPDATE ROI_AdjustStockTransaction
SET AdjQty = 
    CASE 
        WHEN ROI_AdjustmentDetls.IsAdd = 0 THEN -ROI_AdjustmentDetls.Qnty
        ELSE ROI_AdjustmentDetls.Qnty
    END
FROM ROI_AdjustStockTransaction
JOIN ROI_AdjustmentDetls ON ROI_AdjustStockTransaction.AdjTranId = ROI_AdjustmentDetls.ADId
                          AND ROI_AdjustStockTransaction.ItemId = ROI_AdjustmentDetls.ITId;
