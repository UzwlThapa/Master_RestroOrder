SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- [dbo].[USP_getItemledger] 4805, '2022-07-06', '2022-08-06'
CREATE PROCEDURE [dbo].[USP_getItemledger]
    @ItemID INT,
    @FromDate DATE,
    @ToDate DATE
AS
BEGIN
    DECLARE @OpPurchase DECIMAL(18, 2),
            @OpSales DECIMAL(18, 2),
            @OpeningBalance DECIMAL(18, 2),
            @OpAdjust DECIMAL(18, 2),
            @OpPurchaseReturn DECIMAL(18, 2),
            @ItemName VARCHAR(200),
            @UnitDescription VARCHAR(200),
            @OpComp DECIMAL(18, 2);


    SELECT @OpeningBalance = ISNULL(SUM(OPBal), 0)
    FROM ROI_ITEMBal
    WHERE ITId = @ItemID;

    SELECT @ItemName = im.ITName,
           @UnitDescription = u.UnitDescription
    FROM dbo.ROI_ITEMMain im
        INNER JOIN ROI_ItemDetails id
            ON im.ITId = id.ITId
               AND im.ITId = @ItemID
        LEFT JOIN ROI_Unit1 u
            ON id.SmallUnit = u.Unit1Id;

    SELECT @OpSales = ISNULL(SUM(sd.qty * i.Quantity), 0.00)
    FROM RO_SalesMaster sm
        INNER JOIN CBMS_BillPostLog bp
            ON bp.SalesMasterId = sm.salesMasterId
        INNER JOIN RO_SalesDetail sd
            ON sm.salesMasterId = sd.salesMasterId
        INNER JOIN [dbo].[Ro_Ingredient] i
            ON i.ItemID = sd.ItemId
               AND i.Ingredient = @ItemID
        INNER JOIN dbo.ROI_ITEMMain im
            ON i.Ingredient = im.ITId
        INNER JOIN dbo.ROI_ItemDetails id
            ON i.Ingredient = id.ITId
        LEFT JOIN dbo.ROI_Unit1 u
            ON id.SmallUnit = u.Unit1Id
    WHERE CAST(sm.BillDate AS DATE) < @FromDate
          AND sm.IsArchived = 0;

    SELECT @OpPurchase = ISNULL(SUM(it.Qnty * ISNULL(u2.Conversion, 1)), 0.00)
    FROM RO_GoodsReceivedMain p
        INNER JOIN RO_GoodsReceivedDetls it
            ON p.GMId = it.GMId
        INNER JOIN ROI_PurchaseDetails pd
            ON pd.PurchaseDetailsID = it.PDId
               AND pd.ItemID = @ItemID
        INNER JOIN ROI_ItemDetails id
            ON pd.ItemID = id.ITId
        LEFT JOIN ROI_Unit2 u2
            ON pd.UsedUnitID = u2.FirstUnit
               AND id.SmallUnit = u2.SecondUnit
    WHERE CAST(p.InvoiceDate AS DATE) < @FromDate
    GROUP BY pd.ItemID;

    SELECT @OpPurchaseReturn = ISNULL(SUM(pd.Qnty * ISNULL(u2.Conversion, 1)), 0.00)
    FROM RO_PurchaseReturnMain p
        INNER JOIN RO_PurchaseReturnDetails pd
            ON p.PurchaseReturnId = pd.PurchaseReturnId
        INNER JOIN ROI_ItemDetails id
            ON pd.ItemID = id.ITId
               AND pd.ItemID = @ItemID
        LEFT JOIN ROI_Unit2 u2
            ON pd.UsedUnitID = u2.FirstUnit
               AND id.SmallUnit = u2.SecondUnit
    WHERE CAST(p.PostedOn AS DATE) < @FromDate
    GROUP BY pd.ItemID;



    IF (OBJECT_ID('tempdb..#temp') > 0)
        DROP TABLE #temp;

    SELECT CASE
               WHEN ad.IsAdd = 1 THEN
                   SUM(ad.Qnty)
               ELSE
                   SUM(-ad.Qnty)
           END Adjustment
    INTO #temp
    FROM ROI_AdjustmentMain am
        INNER JOIN ROI_AdjustmentDetls ad
            ON am.AMId = ad.AMId
               AND ad.ITId = @ItemID
        INNER JOIN ROI_ItemDetails id
            ON ad.ITId = id.ITId
        LEFT JOIN ROI_Unit2 u2
            ON ad.UsedUnitId = u2.FirstUnit
               AND id.SmallUnit = u2.SecondUnit
        LEFT JOIN dbo.ROI_Unit1 u
            ON id.SmallUnit = u.Unit1Id
    WHERE CAST(am.PostedOn AS DATE) < @FromDate
    GROUP BY ad.ITId,
             ad.IsAdd;

    SELECT @OpAdjust = SUM(Adjustment)
    FROM #temp;

    IF (OBJECT_ID('tempdb..#temp2') > 0)
        DROP TABLE #temp2;

    SELECT SUM(SM.Quantity * i.Quantity) Quantity
    INTO #temp2
    FROM RO_ComplementaryItems SM
        INNER JOIN tblComplementaryMaster CI
            ON SM.CompMasterID = CI.CompMasterID
        INNER JOIN ROI_ItemDetails itd
            ON SM.ROI_ItemId = itd.ITId
        INNER JOIN [dbo].[Ro_Ingredient] i
            ON i.ItemID = itd.ITId
               AND i.Ingredient = @ItemID
        INNER JOIN dbo.ROI_ITEMMain im
            ON i.Ingredient = im.ITId
        INNER JOIN dbo.ROI_ItemDetails id
            ON i.Ingredient = id.ITId
        LEFT JOIN dbo.ROI_Unit1 u
            ON id.SmallUnit = u.Unit1Id
    WHERE CAST(SM.Date AS DATE) < @FromDate
          AND ISNULL(SM.IsArchived, 0) = 0
          AND SM.IsCombo = 0
    GROUP BY im.ITName,
             CAST(SM.Date AS DATE),
             u.UnitDescription;

    SELECT @OpComp = SUM(Quantity)
    FROM #temp2;
    DECLARE @ItemLedger TABLE
    (
        ID INT IDENTITY(1, 1),
        [Date] DATE,
        Item VARCHAR(200),
        SalesQty DECIMAL(18, 2),
        PurchaseQty DECIMAL(18, 2),
        Complimentry DECIMAL(18, 2),
        Adjustment DECIMAL(18, 2),
        PurchaseReturn DECIMAL(18, 2),
        Balance DECIMAL(18, 2),
        Unit VARCHAR(100)
    );

    --select @OpPurchase, @OpSales
    SELECT @OpeningBalance
        = (ISNULL(@OpeningBalance, 0) + ISNULL(@OpPurchase, 0) - ISNULL(@OpSales, 0) + ISNULL(@OpAdjust, 0)
           - ISNULL(@OpPurchaseReturn, 0) - ISNULL(@OpComp, 0)
          );


    INSERT INTO @ItemLedger
    (
        [Date],
        Item,
        SalesQty,
        PurchaseQty,
        Complimentry,
        Adjustment,
        PurchaseReturn,
        Balance,
        Unit
    )
    SELECT @FromDate AS [Date],
           @ItemName Item,
           0 SalesQty,
           0 PurchaseQty,
           0 Complimentry,
           0 Adjustment,
           0 PurchaseReturn,
           @OpeningBalance Balance,
           @UnitDescription UnitDescription;


    --If(OBJECT_ID('tempdb..#tempItemLedger')>0 )
    --drop table #tempItemLedger
    INSERT INTO @ItemLedger
    (
        [Date],
        Item,
        SalesQty,
        PurchaseQty,
        Complimentry,
        Adjustment,
        PurchaseReturn,
        Balance,
        Unit
    )
    SELECT [Date],
           ITName,
           SUM(SalesQty),
           SUM(PurchaseQty),
           SUM(Complimentry),
           SUM(Adjustment),
           PurchaseReturn,
           0 AS Balance,
           UnitDescription
    FROM
    (
        SELECT CAST(sm.BillDate AS DATE) AS [Date],
               im.ITName,
               SUM(sd.qty * i.Quantity) AS SalesQty,
               0 PurchaseQty,
               0 Complimentry,
               0 Adjustment,
               0 PurchaseReturn,
               0 AS Balance,
               u.UnitDescription
        FROM RO_SalesMaster sm
            INNER JOIN CBMS_BillPostLog bp
                ON bp.SalesMasterId = sm.salesMasterId
            INNER JOIN RO_SalesDetail sd
                ON sm.salesMasterId = sd.salesMasterId
                   AND sd.IsCombo = 0
            INNER JOIN [dbo].[Ro_Ingredient] i
                ON i.ItemID = sd.ItemId
                   AND i.Ingredient = @ItemID
            INNER JOIN dbo.ROI_ITEMMain im
                ON i.Ingredient = im.ITId
            INNER JOIN dbo.ROI_ItemDetails id
                ON i.Ingredient = id.ITId
            LEFT JOIN dbo.ROI_Unit1 u
                ON id.SmallUnit = u.Unit1Id
        WHERE CAST(sm.BillDate AS DATE)
              BETWEEN @FromDate AND @ToDate
              AND sm.IsArchived = 0
        GROUP BY im.ITName,
                 CAST(sm.BillDate AS DATE),
                 u.UnitDescription
        UNION ALL
        SELECT CAST(sm.BillDate AS DATE) AS [Date],
               im.ITName,
               SUM(sd.qty * i.Quantity) AS SalesQty,
               0 PurchaseQty,
               0 Complimentry,
               0 Adjustment,
               0 PurchaseReturn,
               0 AS Balance,
               u.UnitDescription
        FROM RO_SalesMaster sm
            INNER JOIN RO_SalesDetail sd
                ON sm.salesMasterId = sd.salesMasterId
                   AND sd.IsCombo = 1
            INNER JOIN RO_Combo CO
                ON CO.ComboID = sd.ItemId
            INNER JOIN RO_ComboDetails ctd
                ON CO.ComboID = ctd.ComboID
            INNER JOIN [dbo].[Ro_Ingredient] i
                ON i.ItemID = ctd.ItemID
                   AND i.Ingredient = @ItemID
            INNER JOIN dbo.ROI_ITEMMain im
                ON i.Ingredient = im.ITId
            INNER JOIN dbo.ROI_ItemDetails id
                ON i.Ingredient = id.ITId
            LEFT JOIN dbo.ROI_Unit1 u
                ON id.SmallUnit = u.Unit1Id
        WHERE CAST(sm.BillDate AS DATE)
              BETWEEN @FromDate AND @ToDate
              AND sm.IsArchived = 0
        GROUP BY im.ITName,
                 CAST(sm.BillDate AS DATE),
                 u.UnitDescription
        UNION ALL
        SELECT CAST(p.InvoiceDate AS DATE) AS [Date],
               @ItemName Item,
               0 SalesQty,
               SUM(it.Qnty * ISNULL(u2.Conversion, 1)) AS PurchaseQty,
               0 Complimentry,
               0 AS Adjustment,
               0 PurchaseReturn,
               0 AS Balance,
               u.UnitDescription
        FROM RO_GoodsReceivedMain p
            INNER JOIN RO_GoodsReceivedDetls it
                ON p.GMId = it.GMId
            INNER JOIN ROI_PurchaseDetails pd
                ON pd.PurchaseDetailsID = it.PDId
                   AND pd.ItemID = @ItemID
            INNER JOIN ROI_ItemDetails id
                ON pd.ItemID = id.ITId
            LEFT JOIN ROI_Unit2 u2
                ON pd.UsedUnitID = u2.FirstUnit
                   AND id.SmallUnit = u2.SecondUnit
                   AND ISNULL(u2.IsArchived, 0) <> 1
            LEFT JOIN dbo.ROI_Unit1 u
                ON id.SmallUnit = u.Unit1Id
        WHERE CAST(p.InvoiceDate AS DATE)
        BETWEEN @FromDate AND @ToDate
        GROUP BY pd.ItemID,
                 CAST(p.InvoiceDate AS DATE),
                 u.UnitDescription
        UNION ALL
        SELECT CAST(am.PostedOn AS DATE) AS [Date],
               @ItemName Item,
               0 SalesQty,
               0 PurchaseQty,
               0 Complimentry,
               CASE
                   WHEN ad.IsAdd = 1 THEN
                       SUM(ad.Qnty)
                   ELSE
                       SUM(-ad.Qnty)
               END Adjustment,
               0 PurchaseReturn,
               0 AS Balance,
               u.UnitDescription
        FROM ROI_AdjustmentMain am
            INNER JOIN ROI_AdjustmentDetls ad
                ON am.AMId = ad.AMId
                   AND ad.ITId = @ItemID
            INNER JOIN ROI_ItemDetails id
                ON ad.ITId = id.ITId
            LEFT JOIN ROI_Unit2 u2
                ON ad.UsedUnitId = u2.FirstUnit
                   AND id.SmallUnit = u2.SecondUnit
            LEFT JOIN dbo.ROI_Unit1 u
                ON id.SmallUnit = u.Unit1Id
        WHERE CAST(am.PostedOn AS DATE)
        BETWEEN @FromDate AND @ToDate
        GROUP BY ad.ITId,
                 am.PostedOn,
                 u.UnitDescription,
                 ad.IsAdd
        UNION ALL
        SELECT CAST(SM.Date AS DATE) AS [Date],
               im.ITName Item,
               0 SalesQty,
               0 PurchaseQty,
               SUM(SM.Quantity * i.Quantity) AS Complimentry,
               0 Adjustment,
               0 PurchaseReturn,
               0 AS Balance,
               u.UnitDescription
        FROM RO_ComplementaryItems SM
            INNER JOIN tblComplementaryMaster CI
                ON SM.CompMasterID = CI.CompMasterID
            INNER JOIN ROI_ItemDetails itd
                ON SM.ROI_ItemId = itd.ITId
            INNER JOIN [dbo].[Ro_Ingredient] i
                ON i.ItemID = itd.ITId
                   AND i.Ingredient = @ItemID
            INNER JOIN dbo.ROI_ITEMMain im
                ON i.Ingredient = im.ITId
            INNER JOIN dbo.ROI_ItemDetails id
                ON i.Ingredient = id.ITId
            LEFT JOIN dbo.ROI_Unit1 u
                ON id.SmallUnit = u.Unit1Id
        WHERE CAST(SM.Date AS DATE)
              BETWEEN @FromDate AND @ToDate
              AND ISNULL(SM.IsArchived, 0) = 0
              AND SM.IsCombo = 0
        GROUP BY im.ITName,
                 CAST(SM.Date AS DATE),
                 u.UnitDescription
        UNION ALL
        SELECT CAST(SM.Date AS DATE) AS [Date],
               im.ITName Item,
               0 SalesQty,
               0 PurchaseQty,
               SUM(SM.Quantity * i.Quantity) AS Complimentry,
               0 Adjustment,
               0 PurchaseReturn,
               0 AS Balance,
               u.UnitDescription
        FROM RO_ComplementaryItems SM
            INNER JOIN tblComplementaryMaster CI
                ON SM.CompMasterID = CI.CompMasterID
            INNER JOIN RO_Combo CO
                ON CO.ComboID = SM.ROI_ItemId
            INNER JOIN RO_ComboDetails ctd
                ON CO.ComboID = ctd.ComboID
            INNER JOIN ROI_ItemDetails itd
                ON ctd.ItemID = itd.ITId
            INNER JOIN [dbo].[Ro_Ingredient] i
                ON i.ItemID = itd.ITId
                   AND i.Ingredient = @ItemID
            INNER JOIN dbo.ROI_ITEMMain im
                ON i.Ingredient = im.ITId
            INNER JOIN dbo.ROI_ItemDetails id
                ON i.Ingredient = id.ITId
            LEFT JOIN dbo.ROI_Unit1 u
                ON id.SmallUnit = u.Unit1Id
        WHERE CAST(SM.Date AS DATE)
              BETWEEN @FromDate AND @ToDate
              AND ISNULL(SM.IsArchived, 0) = 0
              AND SM.IsCombo = 1
        GROUP BY im.ITName,
                 CAST(SM.Date AS DATE),
                 u.UnitDescription
        UNION ALL
        SELECT CAST(p.PostedOn AS DATE) AS [Date],
               @ItemName Item,
               0 SalesQty,
               0 PurchaseQty,
               0 AS Complimentry,
               0 AS Adjustment,
               SUM(pd.Qnty * ISNULL(u2.Conversion, 1)) AS PurchaseReturn,
               0 AS Balance,
               u.UnitDescription
        FROM RO_PurchaseReturnMain p
            INNER JOIN RO_PurchaseReturnDetails pd
                ON p.PurchaseReturnId = pd.PurchaseReturnId
            INNER JOIN ROI_ItemDetails id
                ON pd.ItemID = id.ITId
                   AND pd.ItemID = @ItemID
            LEFT JOIN ROI_Unit2 u2
                ON pd.UsedUnitID = u2.FirstUnit
                   AND id.SmallUnit = u2.SecondUnit
            LEFT JOIN dbo.ROI_Unit1 u
                ON id.SmallUnit = u.Unit1Id
        WHERE CAST(p.PostedOn AS DATE)
        BETWEEN @FromDate AND @ToDate
        GROUP BY pd.ItemID,
                 CAST(p.PostedOn AS DATE),
                 u.UnitDescription
    ) x
    GROUP BY x.[Date],
             x.ITName,
             x.PurchaseReturn,
             x.Balance,
             UnitDescription
    ORDER BY x.[Date];

    --select * from @ItemLedger

    DECLARE @ID INT,
            @curr_Balance DECIMAL(18, 2),
            @SalesQty DECIMAL(18, 2),
            @PurchaseQty DECIMAL(18, 2),
            @Complimentry DECIMAL(18, 2),
            @Adjustment DECIMAL(18, 2),
            @PurchaseReturn DECIMAL(18, 2);
    SET @curr_Balance = @OpeningBalance;
    DECLARE cur_ItemBalance CURSOR FOR
    SELECT ID,
           SalesQty,
           PurchaseQty,
           Complimentry,
           Adjustment,
           PurchaseReturn
    FROM @ItemLedger;
    OPEN cur_ItemBalance;
    FETCH NEXT FROM cur_ItemBalance
    INTO @ID,
         @SalesQty,
         @PurchaseQty,
         @Complimentry,
         @Adjustment,
         @PurchaseReturn;
    WHILE @@FETCH_STATUS = 0
    BEGIN
        SET @curr_Balance
            = ISNULL(@curr_Balance, 0.00) + ISNULL(@PurchaseQty, 0.00) - ISNULL(@SalesQty, 0.00)
              + ISNULL(@Adjustment, 0.00) - ISNULL(@Complimentry, 0.00) - ISNULL(@PurchaseReturn, 0);
        UPDATE @ItemLedger
        SET Balance = @curr_Balance
        WHERE ID = @ID;

        FETCH NEXT FROM cur_ItemBalance
        INTO @ID,
             @SalesQty,
             @PurchaseQty,
             @Complimentry,
             @Adjustment,
             @PurchaseReturn;
    END;
    CLOSE cur_ItemBalance;
    DEALLOCATE cur_ItemBalance;


    SELECT [Date],
           Item,
           SalesQty,
           PurchaseQty,
           Complimentry,
           Adjustment,
           PurchaseReturn,
           Balance,
           Unit
    FROM @ItemLedger;
END;

GO
