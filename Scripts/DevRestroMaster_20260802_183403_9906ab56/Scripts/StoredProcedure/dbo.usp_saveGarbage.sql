SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_saveGarbage]
@ITId int
,@Quantity decimal(10, 2)
,@OrderDetailsID int
,@TableId int
,@OrderMasterID int
,@Addedby varchar(250)
,@IsCombo bit
,@Remarks nvarchar(max)
as 
BEGIN
INSERT INTO RO_GarbageDetail
(
ITId
,Quantity
,OrderDetailsID
,TableId
,Addedby
,AddedOn
,IsCombo
,Remarks
)
VALUES
(
@ITId
,@Quantity
,@OrderDetailsID
,@TableId
,@Addedby
,getdate()
,@IsCombo
,@Remarks
)

DECLARE @garbageID int 

select @garbageID =@@IDENTITY 

BEGIN
		IF (@IsCombo = 0)
		BEGIN
		
				INSERT INTO RO_GarbageIngredientDetails (IngredientId, Quantity, Unit, ItemCostCentreID, GarbageDetailId, ITId, IsCombo)
				SELECT		  ri.Ingredient, ri.Quantity,ids.SmallUnit, ids.ItemCostCentreID,@@IDENTITY,@ITId,@IsCombo
				FROM          Ro_Ingredient AS ri 
							  INNER JOIN ROI_ItemDetails AS ids ON ids.ITId = ri.Ingredient
							   left join ROI_Unit1 u1 on u1.Unit1Id=ids.SmallUnit
				WHERE        (ri.ItemID = @ITId) and ri.Ingredient <>0

				UPDATE ROI_ITEMBal
				SET CLBal = (ib.CLBal - ri.Quantity * @Quantity)
				FROM ROI_ITEMBal ib
				JOIN Ro_Ingredient ri ON ib.ITId = ri.Ingredient
				JOIN ROI_ItemDetails ids ON ids.ITId = @ITId
				JOIN CostCenterInfo ccif ON ccif.CostCenterId = ids.ItemCostCentreID
				WHERE ri.ItemID = @ITId
				AND ib.STId = ccif.StoreId


		END
				ELSE
		BEGIN
		DECLARE @IngredientDetail TABLE
				(
				  ItemID int,
				  IngredientId int,
				  Quantity decimal(10,2)
				)

			DECLARE @MyCursor CURSOR;DECLARE @MyField INT;SET @MyCursor = CURSOR
			FOR
			SELECT cd.ComboDetailsID
			FROM RO_ComboDetails cd
			WHERE cd.ComboID = @ITId

			OPEN @MyCursor

			FETCH NEXT
			FROM @MyCursor
			INTO @MyField

			WHILE @@FETCH_STATUS = 0
			BEGIN		
				INSERT @IngredientDetail
				select  ri.ItemID, ri.Ingredient as IngredientId, ri.Quantity
				FROM Ro_Ingredient ri 
				JOIN ROI_ItemDetails ids ON ids.ITId = (
						SELECT ItemID
						FROM RO_ComboDetails
						WHERE ComboDetailsID = @MyField
						)					
				WHERE ri.ItemID = ids.ITId
				AND ri.Ingredient <> 0
				AND ids.IsArchived =0


				INSERT INTO RO_GarbageIngredientDetails (IngredientId, Quantity, Unit, ItemCostCentreID, GarbageDetailId, ITId, IsCombo)
				SELECT  rd.IngredientId,  rd.Quantity, id.SmallUnit, id.ItemCostCentreID,@garbageID , rd.ItemID ,@IsCombo                       
				FROM   @IngredientDetail AS rd INNER JOIN
                         ROI_ItemDetails AS id ON rd.IngredientId = id.ITId

				delete from @IngredientDetail

				UPDATE ROI_ITEMBal
				SET CLBal = (
						ib.CLBal - ri.Quantity * (
							SELECT Quantity
							FROM RO_ComboDetails
							WHERE ComboDetailsID = @MyField
							)
						)
				FROM ROI_ITEMBal ib
				JOIN Ro_Ingredient ri ON ib.ITId = ri.Ingredient
				JOIN ROI_ItemDetails ids ON ids.ITId = (
						SELECT ItemID
						FROM RO_ComboDetails
						WHERE ComboDetailsID = @MyField
						)
				JOIN CostCenterInfo ccif ON ccif.CostCenterId = ids.ItemCostCentreID
				WHERE ri.ItemID = ids.ITId
					AND ib.STId = ccif.StoreId



				FETCH NEXT
				FROM @MyCursor
				INTO @MyField
			END;

			CLOSE @MyCursor;

			DEALLOCATE @MyCursor;
		END

		DECLARE @qnty INT
				SELECT
					@qnty = Quantity
					FROM RO_Order_Detail od
					INNER JOIN RO_OrderItemStatus ois ON ois.OrderDetailID = od.OrderDetailsID
					WHERE ois.StatusID = 3
						AND od.IsCancelled = 0
						and isnull(od.BillPaid,0)=0
						AND od.OrderDetailsID = @OrderDetailsID
					ORDER BY OrderDetailsID DESC

			IF (@qnty < @Quantity or @qnty = @Quantity)
			BEGIN
				UPDATE RO_Order_Detail
				SET IsCancelled = 1
				WHERE OrderDetailsID =@OrderDetailsID 
					
			END
			ELSE
			BEGIN
				
				UPDATE RO_Order_Detail
				SET Quantity = (Quantity - @Quantity)
				WHERE OrderDetailsID = @OrderDetailsID 

			END
IF (
			(
				SELECT count(*)
				FROM RO_Order_Detail
				WHERE OrderMasterID = @OrderMasterID
					AND IsCancelled = 0
				) = 0
			)
	BEGIN
		UPDATE RO_OrderMasters
		SET IsCancelled = 1
		WHERE OrderMasterID = @OrderMasterID

		UPDATE dbo.RO_restroTable
		SET restrotablesStatusID = 6
		WHERE restrotableId = @TableId

		UPDATE RO_MergeTable
		SET MergeTableList = 0
		WHERE MergeTableList = @TableId

		END
		
			--	DECLARE @Item varchar(250)
			--	,@Orderby varchar(250)

			--	select @Item = ITName from ROI_ITEMMain where ITId=@ITId
			--	select @Orderby=UserName from RO_OrderMasters where OrderMasterID= @OrderMasterID

			--INSERT INTO Order_Detail_Cancel (
			--	CanceledBy
			--	,OrderBy
			--	,Item
			--	,Quantity
			--	,Reason
			--	,DATE
			--	,Responsible
			--	,tableid
			--	,orderMasterID
			--	)
			--VALUES (
			--	@Addedby 
			--	,@Orderby  
			--	,@Item
			--	,@Quantity
			--	,'Garbage'
			--	,getdate()
			--	,'Chef'
			--	,@TableId
			--	,@OrderMasterID
			--	)

			END
	
	END

GO
