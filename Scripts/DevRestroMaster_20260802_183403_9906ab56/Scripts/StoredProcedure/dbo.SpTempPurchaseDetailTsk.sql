SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
====================================
	Author: Yawahang
    Creadted Date: Unknown
	Last Modified By: Yawahang
	Last Modified Date: 11/22/2023
====================================

 EXEC dbo.SpTempPurchaseDetailTsk @ItemID= 258, @Quantity =3
*/
CREATE PROCEDURE [dbo].[SpTempPurchaseDetailTsk]
(
    @ItemID INT = 0 ,
    @Quantity DECIMAL (18, 4) = 0 )
AS
    BEGIN
        CREATE TABLE #tempItem
        (   Id INT IDENTITY (1, 1) ,
            [ItemBalance] DECIMAL (18, 2) ,
            [IngredientId] INT ,
            [Quantity] DECIMAL (18, 2));

        CREATE TABLE #tempItemBalCurrent
        (   Id INT IDENTITY (1, 1) ,
            [ItemBalance] DECIMAL (18, 2) ,
            [IngredientId] INT ,
            [Quantity] DECIMAL (18, 2));

        INSERT #tempItem ( ItemBalance ,
                           IngredientId ,
                           Quantity )
               SELECT ISNULL (bal.ItemBalance, 0) ,
                      RI.Ingredient AS IngredientId ,
                      RI.Quantity
               FROM   dbo.Ro_Ingredient RI
                      INNER JOIN dbo.ROI_ITEMMain RIM ON RIM.ITId = RI.Ingredient
                      OUTER APPLY ( SELECT   TOP ( 1 ) STM.StockTranMasterId ,
                                                       STM.ItemId ,
                                                       STM.ItemBalance
                                    FROM     dbo.ROI_StockTransactionMaster AS STM
                                    WHERE    STM.ItemId = RIM.ITId
                                    ORDER BY STM.StockTranMasterId DESC ) AS bal
               WHERE  RI.ItemID = @ItemID;

        -- stock balance minus total ordered stock is current stock balance
        INSERT #tempItemBalCurrent ( ItemBalance ,
                                     IngredientId ,
                                     Quantity )
               SELECT ISNULL (ti.ItemBalance, 0) - ( ti.Quantity * t.Quantity ) ,
                      ti.IngredientId ,
                      ti.Quantity
               FROM   #tempItem AS ti
                      INNER JOIN ( SELECT DISTINCT ri.Ingredient ,
                                                   tt.Quantity
                                   FROM   dbo.Ro_Ingredient AS ri
                                          INNER JOIN dbo.ROI_ITEMMain AS rim ON rim.ITId = ri.Ingredient
                                          INNER JOIN ( SELECT   tpd.ROI_ItemId ,
                                                                SUM (tpd.Quantity) AS Quantity
                                                       FROM     dbo.RO_Order_Detail AS tpd
                                                                INNER JOIN dbo.RO_OrderItemStatus AS rois ON rois.OrderDetailID = tpd.OrderDetailsID
                                                       WHERE    ISNULL (tpd.IsCancelled, 0) = 0
                                                       AND      rois.StatusID = 1
                                                       AND      tpd.ROI_ItemId = @ItemID
                                                       GROUP BY tpd.ROI_ItemId ) tt ON tt.ROI_ItemId = ri.ItemID
                                   WHERE  ri.ItemID = @ItemID ) AS t ON t.Ingredient = ti.IngredientId;

        DECLARE @IngredientId INT ,
                @Id INT ,
                @UsedUnitId INT ,
                @ItemBalance DECIMAL (18, 2) ,
                @IngQuantity DECIMAL (18, 2) ,
                @IngSalesQuantity DECIMAL (18, 2) ,
                @Conversion INT ,
                @fyId INT ,
                @PurchaseMainID INT ,
                @OverPurchaseQty DECIMAL (18, 2);

        CREATE TABLE [#tempUnit]
        (   [UnitID] INT ,
            [Conversion] INT ,
            [Symbol] VARCHAR (50) ,
            [UnitDescription] VARCHAR (50) ,
            [IsFirst] INT ,
            [IsExpirable] BIT ,
            [ItemID] INT );

        WHILE EXISTS ( SELECT   TOP ( 1 ) 1
                       FROM     #tempItemBalCurrent AS ti
                       ORDER BY ti.Id )
            BEGIN

                SELECT   TOP ( 1 ) @IngredientId = ti.IngredientId ,
                                   @Id = ti.Id ,
                                   @ItemBalance = ti.ItemBalance ,
                                   @IngQuantity = ti.Quantity
                FROM     #tempItemBalCurrent AS ti
                ORDER BY ti.Id;

                SELECT @IngSalesQuantity = @Quantity * @IngQuantity;

                IF ( @ItemBalance < 0 )
                    BEGIN
                        INSERT #tempUnit ( UnitID ,
                                           Conversion ,
                                           Symbol ,
                                           UnitDescription ,
                                           IsFirst ,
                                           IsExpirable ,
                                           ItemID )
                               SELECT u.Unit1Id AS UnitID ,
                                      1 AS Conversion ,
                                      u.Symbol AS Symbol ,
                                      u.UnitDescription AS UnitDescription ,
                                      1 AS IsFirst ,
                                      ( SELECT IsExpirable
                                        FROM   dbo.ROI_ItemDetails
                                        WHERE  ITId = @ItemID ) AS IsExpirable ,
                                      @IngredientId AS ItemID
                               FROM   dbo.ROI_Unit1 u
                               WHERE  IsArchived = 0
                               AND    Unit1Id = ( SELECT SmallUnit
                                                  FROM   dbo.ROI_ItemDetails
                                                  WHERE  ITId = @IngredientId )
                               UNION
                               SELECT u.FirstUnit AS UnitID ,
                                      u.Conversion ,
                                      u1.Symbol AS Symbol ,
                                      u1.UnitDescription AS UnitDescription ,
                                      0 AS IsFirst ,
                                      ( SELECT IsExpirable
                                        FROM   dbo.ROI_ItemDetails
                                        WHERE  ITId = @ItemID ) AS IsExpirable ,
                                      @IngredientId AS ItemID
                               FROM   dbo.ROI_Unit2 u
                                      INNER JOIN dbo.ROI_Unit1 u1 ON u.FirstUnit = u1.Unit1Id
                                      INNER JOIN dbo.ROI_Unit1 u2 ON u.SecondUnit = u2.Unit1Id
                               WHERE  u.IsArchived = 0
                               AND    u2.IsArchived = 0
                               AND    u.SecondUnit = ( SELECT SmallUnit
                                                       FROM   dbo.ROI_ItemDetails
                                                       WHERE  ITId = @IngredientId );


                        SELECT @UsedUnitId = tu.UnitID ,
                               @Conversion = tu.Conversion
                        FROM   #tempUnit AS tu
                        WHERE  tu.ItemID = @IngredientId;

                        SELECT @OverPurchaseQty = @ItemBalance * -1;
                        --- maintain TempPurchaseDetail
                        IF EXISTS ( SELECT TOP ( 1 ) 1
                                    FROM   dbo.TempPurchaseDetail AS tpd
                                    WHERE  tpd.ItemID = @IngredientId )
                            BEGIN

                                UPDATE tpd
                                SET    tpd.Quantity = @OverPurchaseQty
                                FROM   dbo.TempPurchaseDetail AS tpd
                                WHERE  tpd.ItemID = @IngredientId;
                            END;
                        ELSE
                            BEGIN
                                INSERT dbo.TempPurchaseDetail ( ItemID ,
                                                                Quantity )
                                       SELECT @IngredientId ,
                                              @OverPurchaseQty;
                            END;

                        -- OutOfStock Sales ROI_PurchaseMain 
                        IF EXISTS ( SELECT TOP ( 1 ) 1
                                    FROM   dbo.ROI_PurchaseMain AS tpd
                                    WHERE  tpd.PostedBy = 'systemAuto' )
                            BEGIN

                                SELECT   TOP ( 1 ) @PurchaseMainID = tpd.PurchaseMainID
                                FROM     dbo.ROI_PurchaseMain AS tpd
                                WHERE    tpd.PostedBy = 'systemAuto'
                                ORDER BY tpd.PurchaseMainID DESC;

                                -- update existing purchase items
                                IF EXISTS ( SELECT TOP ( 1 ) 1
                                            FROM   dbo.ROI_PurchaseDetails AS tpd
                                            WHERE  tpd.ItemID = @IngredientId
                                            AND    tpd.PurchaseMainID = @PurchaseMainID )
                                    BEGIN

                                        UPDATE tpd
                                        SET    tpd.Quentity = tpd.Quentity + @IngSalesQuantity
                                        FROM   dbo.ROI_PurchaseDetails AS tpd
                                        WHERE  tpd.ItemID = @IngredientId
                                        AND    tpd.PurchaseMainID = @PurchaseMainID;

                                    END;
                                ELSE
                                    BEGIN

                                        INSERT dbo.ROI_PurchaseDetails ( StoreID ,
                                                                         PurchaseMainID ,
                                                                         ItemID ,
                                                                         UsedUnitID ,
                                                                         Quentity ,
                                                                         QuentityText ,
                                                                         UnitRate ,
                                                                         Total ,
                                                                         Conversion ,
                                                                         RecqDetailId ,
                                                                         VendorPurchaseId ,
                                                                         Discount ,
                                                                         IsVat )
                                               SELECT NULL ,
                                                      @PurchaseMainID ,
                                                      @IngredientId ,
                                                      @UsedUnitId ,
                                                      @OverPurchaseQty ,
                                                      @UsedUnitId ,
                                                      0 ,
                                                      0 ,
                                                      @Conversion ,
                                                      0 ,
                                                      0 ,
                                                      0 ,
                                                      0;
                                    END;

                                -- delete items returned and balance is zero
                                IF EXISTS ( SELECT TOP ( 1 ) 1
                                            FROM   dbo.TempPurchaseDetail AS tpd
                                            WHERE  tpd.ItemID = @IngredientId
                                            AND    tpd.Quantity <= 0 )
                                    BEGIN
                                        DELETE tpd
                                        FROM   dbo.ROI_PurchaseDetails AS tpd
                                        WHERE  tpd.ItemID = @IngredientId
                                        AND    tpd.PurchaseMainID = @PurchaseMainID;
                                    END;
                            END;
                        ELSE
                            BEGIN
                                -- insert new purchase & items
                                DECLARE @prefix VARCHAR (128) = 'PO_';
                                DECLARE @PuNo VARCHAR (MAX);
                                DECLARE @val VARCHAR (MAX);
                                IF EXISTS ( SELECT TOP ( 1 ) 1
                                            FROM   dbo.ROI_PurchaseMain )
                                    BEGIN
                                        SELECT @val = CAST(MAX (
                                                               CAST(SUBSTRING (
                                                                        PuNo , LEN (1) + 3, LEN (PuNo) - LEN (@prefix)) AS INT))
                                                           + 1 AS VARCHAR (100))
                                        FROM   dbo.ROI_PurchaseMain;

                                        SET @PuNo = @prefix + @val;
                                    END;
                                ELSE
                                    BEGIN
                                        SET @PuNo = @prefix + CAST(1 AS VARCHAR (1));
                                    END;


                                SELECT   TOP ( 1 ) @fyId = fy.fyId
                                FROM     dbo.RO_fiscalYear fy
                                WHERE    fy.isActive = 1
                                AND      fy.IsDeleted <> 1
                                AND      DATEPART (YEAR, fy.StartDate) = DATEPART (YEAR, GETDATE ())
                                ORDER BY fy.fyId DESC;

                                INSERT dbo.ROI_PurchaseMain ( PuNo ,
                                                              PbDate ,
                                                              IvNo ,
                                                              Vid ,
                                                              Remarks ,
                                                              FyId ,
                                                              PostedOn ,
                                                              PostedBy ,
                                                              SPMID )
                                       SELECT @PuNo ,
                                              GETDATE () ,
                                              'Iv Auto' ,
                                              NULL ,
                                              'OutOfStock Sales' ,
                                              @fyId ,
                                              GETDATE () ,
                                              'systemAuto' ,
                                              NULL;

                                SELECT @PurchaseMainID = SCOPE_IDENTITY ();

                                INSERT dbo.ROI_PurchaseDetails ( StoreID ,
                                                                 PurchaseMainID ,
                                                                 ItemID ,
                                                                 UsedUnitID ,
                                                                 Quentity ,
                                                                 QuentityText ,
                                                                 UnitRate ,
                                                                 Total ,
                                                                 Conversion ,
                                                                 RecqDetailId ,
                                                                 VendorPurchaseId ,
                                                                 Discount ,
                                                                 IsVat )
                                       SELECT NULL ,
                                              @PurchaseMainID ,
                                              @IngredientId ,
                                              @UsedUnitId ,
                                              @OverPurchaseQty ,
                                              @UsedUnitId ,
                                              NULL ,
                                              NULL ,
                                              @Conversion ,
                                              NULL ,
                                              NULL ,
                                              NULL ,
                                              NULL;
                            END;


                        SELECT @UsedUnitId = 0 ,
                               @Conversion = 0;
                        TRUNCATE TABLE #tempUnit;

                        -- delete items returned and balance is zero
                        IF EXISTS ( SELECT TOP ( 1 ) 1
                                    FROM   dbo.TempPurchaseDetail AS tpd
                                    WHERE  tpd.ItemID = @IngredientId
                                    AND    tpd.Quantity <= 0 )
                            BEGIN
                                DELETE tpd
                                FROM   dbo.TempPurchaseDetail AS tpd
                                WHERE  tpd.ItemID = @IngredientId;
                            END;
                    END;

                DELETE ti
                FROM   #tempItemBalCurrent AS ti
                WHERE  ti.Id = @Id;
            END;

        DROP TABLE IF EXISTS #tempUnit;
        DROP TABLE IF EXISTS #tempItem;
        DROP TABLE IF EXISTS #tempItemBalCurrent;

    END;
GO
