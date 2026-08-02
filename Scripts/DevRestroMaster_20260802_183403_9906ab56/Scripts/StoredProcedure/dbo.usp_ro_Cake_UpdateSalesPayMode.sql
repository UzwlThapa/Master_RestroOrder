SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================  
-- Author:  <Saroj Kumar Chaudhary>  
-- Create date: <8-Jan-2021>  
-- Description: <Save cake payment mode details>  
-- EXECUTE: [dbo].[usp_ro_Cake_UpdateSalesPayMode] 0  
-- ============================================= 
CREATE PROCEDURE [dbo].[usp_ro_Cake_UpdateSalesPayMode] @salesMasterId INT
	,@SPMID INT
	,@ChequeNo NVARCHAR(max)
	,@TransactionNo NVARCHAR(max)
	,@ProviderID INT
	,@CusID INT
	,@Customer NVARCHAR(max)
	,@Address NVARCHAR(max)
	,@PAN NVARCHAR(max)
	,@PayAmount DECIMAL(18, 2)
	,@TenderAmount DECIMAL(18, 2)
	,@ReturnAmount DECIMAL(18, 2)
	,@Remarks NVARCHAR(max)
	,@ReturnPayment DECIMAL(18,2) = 0
	,@SalesType nvarchar(30) = null
AS
BEGIN


	INSERT INTO RO_CAKE_SalesPaymentMode (
		salesMasterId
		,PaymentModeID
		,ChequeNo
		,TransactionNo
		,ProviderID
		,CusID
		,Customer
		,Address
		,PAN
		,PayAmount
		,Remarks
		,ReturnPayment
		,SalesType
		)
	VALUES (
		@salesMasterId
		,@SPMID
		,@ChequeNo
		,@TransactionNo
		,@ProviderID
		,@CusID
		,@Customer
		,@Address
		,@PAN
		,@PayAmount
		,@Remarks
		,@ReturnPayment
		,@SalesType
		)

	IF (@SPMID = 1)
	BEGIN
		UPDATE RO_CakeSalesMaster
		SET IsUpdated = 1
		,UpdatedOn = getdate()
			,TenderAmount = @TenderAmount
			,ReturnAmount = @ReturnAmount
		WHERE salesMasterId = @salesMasterId  and SalesType = @SalesType
	END
	ELSE
	BEGIN
		UPDATE RO_CakeSalesMaster
		SET IsUpdated = 1
			,UpdatedOn = getdate()
		WHERE salesMasterId = @salesMasterId and SalesType = @SalesType
	END

	--BEGIN
	--	DECLARE @tableId NVARCHAR(50)
	--		,@ordermasterid INT

	--	SELECT @tableId = sm.TableId
	--		,@ordermasterid = sm.OrderMasterId
	--	FROM RO_SalesMaster sm
	--	WHERE sm.salesMasterId = @salesMasterId

	--	IF (
	--			(
	--				SELECT count(*)
	--				FROM RO_Order_Detail od
	--				WHERE od.OrderMasterId = @ordermasterid
	--					AND isnull(od.BillPaid, 0) = 0
	--					AND isnull(od.IsCancelled, 0) = 0
	--				) = 0
	--				and 
	--				(
	--				select count(*) from ro_salesmaster
	--				where ordermasterid=@ordermasterid
	--				and isnull(isupdated,0)=0 and isnull(isarchived,0)=0
	--				) = 0
					
	--			)
	--	BEGIN
	--		UPDATE ro_mergetable
	--		SET mergetablelist = 0
	--		WHERE mergetablelist = @tableId


	--		If(select IsTable from ro_restrotable WHERE restrotableid = @tableId) =1
	--		begin
	--			UPDATE ro_restrotable
	--			SET restrotablesstatusid = 6
	--			WHERE restrotableid = @tableId

	--		end
	--		ELSE
	--		BEGIN
	--			IF(EXISTS(SELECT 1
	--						FROM Ro_RoomBookings rb 
	--										INNER JOIN RO_OrderMasters om on rb.OrderMasterId=om.OrderMasterID
	--										left join RO_SalesMaster sm on om.OrderMasterID=sm.OrderMasterId and sm.IsUpdated=0
	--						WHERE rb.TableId=@tableId  AND om.BillPaid = 0 AND rb.IsCancelled=0 AND (GETDATE() BETWEEN rb.BookedFrom AND rb.BookedTo)
	--				)
	--			)
	--			BEGIN
	--				UPDATE ro_restrotable
	--				SET restrotablesstatusid = 7
	--				WHERE restrotableid = @tableId
	--			END
	--			ELSE
	--			BEGIN
	--				UPDATE ro_restrotable
	--				SET restrotablesstatusid = 6
	--				WHERE restrotableid = @tableId
	--			END

	--			--select * from RO_SalesMaster
	--		END
	--	END
	--END

END



GO
