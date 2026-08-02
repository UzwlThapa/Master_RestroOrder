SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_RO_restoreOrder]
@salesMasterId int
,@userName nvarchar(max)
as
declare @ordermasterid int, @seatno int,@newordermasterid int
,@istable bit
,@tableId int

select @ordermasterid=OrderMasterId
,@seatno=SeatNo
,@tableId=TableId
from RO_SalesMaster
where salesMasterId=@salesMasterId

if(@tableId > 0)
begin
select @istable = IsTable from RO_restroTable where restrotableId=@tableId
end

insert into RO_OrderMasters(RoomId
	, TableId
	, BillNo
	, Date
	, BasicAmount
	, TermAmount
	, NetAmount
	, Remarks
	, IsCancelled
	, UserName
	, BillPaid
	, IsSplit
	, GuestNo
	, IsPrinted
	, OID
	, OrderStatus
	)
SELECT RoomId
	, TableId
	, BillNo
	, Date
	, 0
	, 0
	, 0
	, ''
	, 0
	, @userName
	, 0
	, 1
	, 1
	, IsPrinted
	, OID
	, OrderStatus 
FROM RO_OrderMasters
 where OrderMasterID=@ordermasterid

select @newordermasterid = cast(@@identity as int)

if(@istable = 0)
begin
insert into Ro_RoomBookings(OrderMasterId, TableId, BookedFrom, BookedTo, IsCancelled, BookedDays, Rate, TotalAmount, AdvancePayment, CustomerId, CustomerName, PhoneNo, EmailAddress, CtznNo)
SELECT        @newordermasterid, TableId, BookedFrom, BookedTo, 0, BookedDays, Rate, TotalAmount, AdvancePayment, CustomerId, CustomerName, PhoneNo, EmailAddress, CtznNo
FROM            Ro_RoomBookings
where OrderMasterId=@ordermasterid
end

Insert into RO_Order_Detail (Quantity
	, Rate
	, Amount
	, Date
	, IsCancelled
	, ItemId
	, OrderMasterId
	, SeatNo
	, Note
	, ExtraCharge
	, BillPaid
	, NetAmount
	, CostCenterId
	, IsRunningOrder
	, ROI_ItemId
	, IsHomeDelivery
	, HomeDeliveyNumber
	, ExtraItem
	, IsCombo)
SELECT        Quantity
	, Rate
	, Amount
	, Date
	, 0
	, ItemId
	, @newordermasterid
	, 1
	, Note
	, ExtraCharge
	, 0
	, NetAmount
	, CostCenterId
	, IsRunningOrder
	, ROI_ItemId
	, IsHomeDelivery
	, HomeDeliveyNumber
	, ExtraItem
	, IsCombo
FROM            RO_Order_Detail
where OrderMasterId = @ordermasterid
and isnull(IsCancelled,0)=0
and SeatNo = @seatno

insert into RO_OrderItemStatus(OrderDetailID, StatusID, [TimeStamp])
SELECT         OrderDetailsID, 1, [Date]
FROM            RO_Order_Detail
where OrderMasterId = @newordermasterid

insert into RO_Order_ExtraItem ( OrderMasterId
	, OrderDetailsID
	, ItemID
	, ExtraItemID
	, ExtraItem
	, Quantity
	, ExtraPrice
	, SeatNo)
SELECT         @newordermasterid
	, (select top 1 OrderDetailsID 
		from RO_Order_Detail 
		where OrderMasterId = @newordermasterid
		and ROI_ItemId=oe.ItemID)
	, oe.ItemID
	, ExtraItemID
	, oe.ExtraItem
	, oe.Quantity
	, ExtraPrice
	, 1
FROM            RO_Order_ExtraItem oe
join RO_Order_Detail od on od.OrderDetailsID = oe.OrderDetailsID
where oe.OrderMasterId = @ordermasterid
	and isnull(IsCancelled,0)=0
	and od.SeatNo = @seatno

		If exists( select * from RO_SalesDetailsIngredient where salesMasterId = @salesMasterId)
	BEGIN
	update RO_SalesDetailsIngredient set IsArchived=1 where salesMasterId = @salesMasterId
	END
	BEGIN
		DECLARE @salesDetails CURSOR;DECLARE @detailID INT;SET @salesDetails = CURSOR
		FOR
		SELECT salesDetailId
		FROM RO_SalesDetail
		WHERE salesMasterId = @salesMasterId

		OPEN @salesDetails

		FETCH NEXT
		FROM @salesDetails
		INTO @detailID

		WHILE @@FETCH_STATUS = 0
		BEGIN
			BEGIN
				IF (
						(
							SELECT IsCombo
							FROM RO_SalesDetail
							WHERE salesDetailId = @detailID
							) = 0
						)
				BEGIN
					UPDATE ROI_ITEMBal
					SET CLBal = (
							ib.CLBal + ri.Quantity * (
								SELECT qty
								FROM RO_SalesDetail
								WHERE salesDetailId = @detailID
								)
							)
					FROM ROI_ITEMBal ib
					JOIN Ro_Ingredient ri ON ib.ITId = ri.Ingredient
					JOIN ROI_ItemDetails ids ON ids.ITId = (
							SELECT ItemId
							FROM RO_SalesDetail
							WHERE salesDetailId = @detailID
							)
					JOIN CostCenterInfo ccif ON ccif.CostCenterId = ids.ItemCostCentreID
					WHERE ri.ItemID = (
							SELECT ItemId
							FROM RO_SalesDetail
							WHERE salesDetailId = @detailID
							)
						AND ib.STId = ccif.StoreId
				END
				ELSE
				BEGIN
					DECLARE @MyCursor CURSOR;DECLARE @MyField INT;SET @MyCursor = CURSOR
					FOR
					SELECT cd.ComboDetailsID
					FROM RO_ComboDetails cd
					WHERE cd.ComboID = (
							SELECT ItemId
							FROM RO_SalesDetail
							WHERE salesDetailId = @detailID
							)

					OPEN @MyCursor

					FETCH NEXT
					FROM @MyCursor
					INTO @MyField

					WHILE @@FETCH_STATUS = 0
					BEGIN
						UPDATE ROI_ITEMBal
						SET CLBal = (
								ib.CLBal + ri.Quantity * (
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
			END

			FETCH NEXT
			FROM @salesDetails
			INTO @detailID
		END;

		CLOSE @salesDetails;

		DEALLOCATE @salesDetails;
	END

	BEGIN
		DECLARE @extraIng CURSOR;DECLARE @extraID INT;SET @extraIng = CURSOR
		FOR
		SELECT ExtraId
		FROM RO_SalesDetailExtra
		WHERE salesMasterId = @salesMasterId

		OPEN @extraIng

		FETCH NEXT
		FROM @extraIng
		INTO @extraID

		WHILE @@FETCH_STATUS = 0
		BEGIN
			BEGIN
				UPDATE ROI_ITEMBal
				SET CLBal = (
						ib.CLBal + (
							ri.Quantity * (
								SELECT Quantity
								FROM RO_SalesDetailExtra
								WHERE ExtraId = @extraID
								)
							)
						)
				FROM ROI_ITEMBal ib
				JOIN RO_ExtraIngredient ri ON ib.ITId = ri.IngredientID
				JOIN ROI_ItemDetails ids ON ids.ITId = ib.ITId
				JOIN CostCenterInfo ccif ON ccif.CostCenterId = ids.ItemCostCentreID
				WHERE ri.ExtraItemID = (
						SELECT ExtraItemId
						FROM RO_SalesDetailExtra
						WHERE ExtraId = @extraID
						)
					AND ib.STId = ccif.StoreId
			END

			FETCH NEXT
			FROM @extraIng
			INTO @extraID
		END;

		CLOSE @extraIng;

		DEALLOCATE @extraIng;
	END




	select * from CBMS_BillReturnPostLog

GO
