SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[USP_SAVECOMPLEMENTARYDETAIL]
(
    @CompMasterID INT ,
    @RO_ItemID INT ,
    @Rate DECIMAL (18, 2) ,
    @IsCancelled BIT ,
    @Quantity FLOAT ,
    @Amount DECIMAL (18, 2) ,
    @Note VARCHAR (256) = NULL ,
    @ExtraCharge DECIMAL (18, 2) ,
    @IsHomeDelivery BIT ,
    @HomeDeliveyNumber INT ,
    @SeatNo INT ,
    @Status NVARCHAR (50) ,
    @IsRunningOrder INT ,
    @IsCombo BIT )
AS
    /*
Updated Query Bishal Raj Parajuli
*/
    BEGIN
        DECLARE @val INT;
        DECLARE @Amount1 DECIMAL (18, 2);
        DECLARE @Rate1 DECIMAL (18, 2);
        DECLARE @CostCenterID INT;

        IF @IsCombo = 0
            BEGIN
                SELECT @CostCenterID = ItemCostCentreID
                FROM   ROI_ItemDetails
                WHERE  ITId = @RO_ItemID;
                SELECT @Rate1 = it.SRate
                FROM   ROI_ItemRate it
                WHERE  it.ItemID = @RO_ItemID;
            END;
        ELSE
            BEGIN
                SELECT @Rate1 = it.SalesPrice ,
                       @CostCenterID = it.CostCenterID
                FROM   RO_Combo it
                WHERE  it.ComboID = @RO_ItemID;
            END;

        SELECT @Amount1 = @Rate1 * @Quantity;
        BEGIN
            INSERT INTO dbo.RO_ComplementaryItems ( CompMasterID ,
                                                ROI_ItemId ,
                                                Rate ,
                                                IsCancelled ,
                                                Quantity ,
                                                Date ,
                                                Amount ,
                                                Note ,
                                                ExtraCharge ,
                                                IsHomeDelivery ,
                                                HomeDeliveyNumber ,
                                                SeatNo ,
                                                CostCenterId ,
                                                IsRunningOrder ,
                                                IsCombo )
            VALUES ( @CompMasterID, @RO_ItemID, @Rate1, @IsCancelled, @Quantity, GETDATE (), @Amount1, @Note ,
                     @ExtraCharge , @IsHomeDelivery, @HomeDeliveyNumber, @SeatNo, @CostCenterID, @IsRunningOrder ,
                     @IsCombo );

            SELECT SCOPE_IDENTITY();

            SET @val = SCOPE_IDENTITY();;

            INSERT INTO dbo.CompItemStatus ( CompId ,
                                         StatusID ,
                                         TimeStamp )
            VALUES ( @val, ( SELECT StatusID
                             FROM   dbo.RO_ItemStatus
                             WHERE  ItemStatus = @Status ), GETDATE ());

        END;
        --Update Stock

        DECLARE @Ingredient INT ,
                @IngredientQty DECIMAL;


        DECLARE Cursor_Ingredient CURSOR FOR(
            SELECT Ingredient ,
                   Quantity * @Quantity AS IngridentQty
            FROM   dbo.Ro_Ingredient
            WHERE  ItemID = @RO_ItemID);


        --CRUSOR FOR INGREDIENT ITEMS
        OPEN Cursor_Ingredient;

        FETCH NEXT FROM Cursor_Ingredient
        INTO @Ingredient ,
             @IngredientQty;

        WHILE @@FETCH_STATUS = 0
            BEGIN

                DECLARE @CompItemId INT = @Ingredient ,
                        @CompQty DECIMAL = @IngredientQty ,
                        @SUnitName INT ,
                        @StoreId INT;


                SELECT @SUnitName = ID.SmallUnit ,
                       @StoreId = CC.StoreId
                FROM   dbo.ROI_ItemDetails ID
                       INNER JOIN dbo.CostCenterInfo CC ON ID.ItemCostCentreID = CC.CostCenterId
                WHERE  ID.ITId = @CompItemId;


                DECLARE @RemainingSQty DECIMAL = @CompQty;

                DECLARE @AvailableQty DECIMAL ,
                        @PurchaseRate DECIMAL ,
                        @StockMasterTranId INT ,
                        @TotalSellAmt DECIMAL = 0 ,
                        @LastBalance DECIMAL (15, 2) ,
                        @LastValue DECIMAL (15, 2) ,
                        @CompRate DECIMAL;

                SET @LastBalance = ISNULL (( SELECT   TOP ( 1 ) ItemBalance
                                             FROM     [dbo].[ROI_StockTransactionMaster]
                                             WHERE    ItemId = @CompItemId
                                             AND      StoreId = @StoreId
                                             ORDER BY StockTranMasterId DESC ) ,
                                           0);
                SET @LastValue = ISNULL (( SELECT   TOP ( 1 ) ItemValue
                                           FROM     [dbo].[ROI_StockTransactionMaster]
                                           WHERE    ItemId = @CompItemId
                                           AND      StoreId = @StoreId
                                           ORDER BY StockTranMasterId DESC ) ,
                                         0);

                --Declare
                DECLARE crusor_transaction CURSOR FOR(
                    SELECT StockTranMasterId ,
                           AvailableQty ,
                           Rate
                    FROM   [dbo].[ROI_StockTransactionMaster]
                    WHERE  ItemId = @CompItemId
                    AND    StoreId = @StoreId
                    AND    AvailableQty IS NOT NULL);


                --Open Crusor
                OPEN crusor_transaction;

                --Fetch From Declare
                FETCH NEXT FROM crusor_transaction
                INTO @StockMasterTranId ,
                     @AvailableQty ,
                     @PurchaseRate;

                WHILE @@FETCH_STATUS = 0
                    BEGIN

                        IF ( @RemainingSQty > @AvailableQty )
                            BEGIN

                                SET @RemainingSQty = @RemainingSQty - @AvailableQty; -- Calculation of Remaining Selling Qty

                                SET @TotalSellAmt = @TotalSellAmt + ( @AvailableQty * @PurchaseRate ); --Calculation of Total Selling Value

                                UPDATE [dbo].[ROI_StockTransactionMaster]
                                SET    AvailableQty = 0
                                WHERE  StockTranMasterId = @StockMasterTranId;

                            END;
                        ELSE --If RemainingSelling Qty is Less than Available Balance 
                            BEGIN

                                SET @TotalSellAmt = @TotalSellAmt + ( @RemainingSQty * @PurchaseRate ); --Calculation of Total Selling Value

                                UPDATE [dbo].[ROI_StockTransactionMaster]
                                SET    AvailableQty = @AvailableQty - @RemainingSQty
                                WHERE  StockTranMasterId = @StockMasterTranId;
                                BREAK;
                            END;


                        FETCH NEXT FROM crusor_transaction
                        INTO @StockMasterTranId ,
                             @AvailableQty ,
                             @PurchaseRate;

                    END;
                CLOSE crusor_transaction;

                DEALLOCATE crusor_transaction;


                INSERT INTO [dbo].[ROI_ComplementryStockTransaction] ( ComplementryDetailId ,
                                                                       StoreId ,
                                                                       ItemId ,
                                                                       CompQty ,
                                                                       CompUnit ,
                                                                       CompAmt ,
                                                                       TransactionDate )
                VALUES ( @val, @StoreId, @CompItemId, @CompQty, @SUnitName, @TotalSellAmt, GETDATE ());

                DECLARE @CompTranId INT = SCOPE_IDENTITY();

                INSERT INTO [dbo].[ROI_StockTransactionMaster] ( CompTranId ,
                                                                 StoreId ,
                                                                 ItemId ,
                                                                 ItemBalance ,
                                                                 ItemBalUnitId ,
                                                                 ItemValue ,
                                                                 TransactionDate )
                VALUES ( @CompTranId, @StoreId, @CompItemId, @LastBalance - @CompQty, @SUnitName ,
                         @LastValue - @TotalSellAmt, GETDATE ());

                --First Crusor Close


                FETCH NEXT FROM Cursor_Ingredient
                INTO @Ingredient ,
                     @IngredientQty;

            END;
        CLOSE Cursor_Ingredient;

        DEALLOCATE Cursor_Ingredient;

    END;



/*
Old Query
*/

--BEGIN  
-- -- IF(@OrderDetailID=0)    
-- DECLARE @val INT  
-- DECLARE @Amount1 DECIMAL(18, 2)  
-- DECLARE @Rate1 DECIMAL(18, 2)  
-- DECLARE @CostCenterID int 
-- if @IsCombo = 0  
-- begin
-- select @CostCenterID= ItemCostCentreID from ROI_ItemDetails WHERE ITId = @RO_ItemID 
--	 SELECT @Rate1 = it.SRate  
--	 FROM ROI_ItemRate it  
--	 WHERE it.ItemID = @RO_ItemID 
-- end 
-- else   
-- begin
--	 SELECT @Rate1 = it.SalesPrice  ,@CostCenterID = it.CostCenterID
--	 FROM RO_Combo it  
--	 WHERE it.ComboID = @RO_ItemID  
-- end

-- SELECT @Amount1 = @Rate1 * @Quantity  





-- BEGIN  
--  INSERT INTO RO_ComplementaryItems (  
--  CompMasterID
--   ,ROI_ItemId  
--   ,Rate  
--   ,IsCancelled  
--   ,Quantity 
--   ,Date 
--   ,Amount  
--   ,Note  
--   ,ExtraCharge  
--   ,IsHomeDelivery  
--   ,HomeDeliveyNumber  
--   ,SeatNo  
--   ,CostCenterId  
--   ,IsRunningOrder  
--   ,IsCombo  
--   )  
--  VALUES (  
--   @CompMasterID
--   ,@RO_ItemID  
--   ,@Rate1  
--   ,@IsCancelled  
--   ,@Quantity 
--    ,GETDATE() 
--   ,@Amount1  
--   ,@Note  
--   ,@ExtraCharge  
--   ,@IsHomeDelivery  
--   ,@HomeDeliveyNumber  
--   ,@SeatNo  
--   ,@CostCenterID  
--   ,@IsRunningOrder  
--   ,@IsCombo  
--   )  

--  SELECT @@IDENTITY  

--  SET @val = @@IDENTITY  

--  INSERT INTO CompItemStatus(  
--   CompId
--   ,StatusID  
--   ,TIMESTAMP  
--   )  
--  VALUES (  
--   @val  
--   ,(  
--    SELECT StatusID  
--    FROM dbo.RO_ItemStatus  
--    WHERE ItemStatus = @Status  
--    )  
--   ,GETDATE()  
--   )  

--   DECLARE @TotalCBl BIGINT = 0BEGIN
--		IF (@IsCombo = 0)
--		BEGIN
--			UPDATE ROI_ITEMBal
--			SET CLBal = (ib.CLBal - ri.Quantity * @Quantity)
--			FROM ROI_ITEMBal ib
--			JOIN Ro_Ingredient ri ON ib.ITId = ri.Ingredient
--			JOIN ROI_ItemDetails ids ON ids.ITId = @RO_ItemID 
--			JOIN CostCenterInfo ccif ON ccif.CostCenterId = ids.ItemCostCentreID
--			WHERE ri.ItemID = @RO_ItemID 
--				AND ib.STId = ccif.StoreId
--		END
--		ELSE
--		BEGIN
--			DECLARE @MyCursor CURSOR;DECLARE @MyField INT;SET @MyCursor = CURSOR
--			FOR
--			SELECT cd.ComboDetailsID
--			FROM RO_ComboDetails cd
--			WHERE cd.ComboID = @RO_ItemID 

--			OPEN @MyCursor

--			FETCH NEXT
--			FROM @MyCursor
--			INTO @MyField

--			WHILE @@FETCH_STATUS = 0
--			BEGIN
--				UPDATE ROI_ITEMBal
--				SET CLBal = (
--						ib.CLBal - ri.Quantity * (
--							SELECT Quantity
--							FROM RO_ComboDetails
--							WHERE ComboDetailsID = @MyField
--							)
--						)
--				FROM ROI_ITEMBal ib
--				JOIN Ro_Ingredient ri ON ib.ITId = ri.Ingredient
--				JOIN ROI_ItemDetails ids ON ids.ITId = (
--						SELECT ItemID
--						FROM RO_ComboDetails
--						WHERE ComboDetailsID = @MyField
--						)
--				JOIN CostCenterInfo ccif ON ccif.CostCenterId = ids.ItemCostCentreID
--				WHERE ri.ItemID = ids.ITId
--					AND ib.STId = ccif.StoreId

--				FETCH NEXT
--				FROM @MyCursor
--				INTO @MyField
--			END;

--			CLOSE @MyCursor;

--			DEALLOCATE @MyCursor;
--		END
--END

--END
--END


GO
