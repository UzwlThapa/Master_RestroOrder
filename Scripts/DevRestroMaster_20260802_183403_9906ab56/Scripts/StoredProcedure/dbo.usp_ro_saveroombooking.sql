SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-----------------------------------------------------------------------------
--DROP PROC [dbo].[usp_ro_saveroombooking]
CREATE PROCEDURE [dbo].[usp_ro_saveroombooking] @TableId INT
	,@OrderMasterID INT
	,@BookedFrom DATETIME
	,@BookedTo DATETIME
	,@BookedDays INT
	,@Rate DECIMAL(18, 2)
	,@TotalAmount DECIMAL(18, 2)
	,@AdvancePayment DECIMAL(18, 2)
	,@CustomerId INT
	,@CustomerName NVARCHAR(max)
	,@PhoneNo NVARCHAR(max)
	,@EmailAddress NVARCHAR(max)
	,@CtznNo NVARCHAR(max)
	,@Remarks nvarchar(max)
AS
BEGIN
	INSERT INTO Ro_RoomBookings (
		OrderMasterId
		,TableId
		,BookedFrom
		,BookedTo
		,IsCancelled
		,BookedDays
		,Rate
		,TotalAmount
		,AdvancePayment
		,CustomerId
		,CustomerName
		,PhoneNo
		,EmailAddress
		,CtznNo
		,Remarks
		)
	VALUES (
		@OrderMasterID
		,@TableId
		,@BookedFrom
		,@BookedTo
		,0
		,@BookedDays
		,@Rate
		,@TotalAmount
		,@AdvancePayment
		,@CustomerId
		,@CustomerName
		,@PhoneNo
		,@EmailAddress
		,@CtznNo
		,@Remarks
		)

		--DECLARE @minBookedDate datetime , @maxBookedDate datetime
		--SELECT @minBookedDate=max(rb.BookedFrom), @maxBookedDate=max(rb.BookedTo) FROM Ro_RoomBookings rb  
		--INNER JOIN RO_OrderMasters om on rb.OrderMasterId=om.OrderMasterID
		--where rb.TableId=@tableId AND om.BillPaid = 0 AND rb.IsCancelled=0 
				IF(EXISTS(SELECT 1
							FROM Ro_RoomBookings rb 
											INNER JOIN RO_OrderMasters om on rb.OrderMasterId=om.OrderMasterID
											left join RO_SalesMaster sm on om.OrderMasterID=sm.OrderMasterId and sm.IsUpdated=0
							WHERE rb.TableId=@tableId  AND om.BillPaid = 0 AND rb.IsCancelled=0  AND (GETDATE() BETWEEN rb.BookedFrom AND rb.BookedTo)
					)
				)
		--if(exists(select 1 from Ro_RoomBookings rb where GETDATE()>@minBookedDate))
				BEGIN
					UPDATE ro_restrotable
					SET restrotablesstatusid = 7
					WHERE restrotableid = @tableId
				END
				ELSE
				BEGIN
					UPDATE ro_restrotable
					SET restrotablesstatusid = 6
					WHERE restrotableid = @tableId
				END


		SELECT CAST(@@IDENTITY AS INT)
END



GO
