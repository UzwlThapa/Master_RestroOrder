SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--[USP_RO_SalesMasterStore] 6864

CREATE PROCEDURE [dbo].[USP_RO_SalesMasterStore]
@ID int

AS
BEGIN

Declare

@BillDate datetime,
@RoomId int,
@TableId int,
@BasicAmount decimal(18, 2),
@TermAmount decimal(18, 2),
@NetAmount decimal(18, 2)
select
--@billNo= BillNo, 
@BillDate= Date,
@RoomId=RoomId, 
@TableId=TableId,
@BasicAmount = BasicAmount, 
@TermAmount = TermAmount,
@NetAmount = NetAmount
from RO_OrderMasters where OrderMasterID=@ID

Declare @billNo nvarchar(128) 
select @billNo= BillNo from RO_OrderMasters where OrderMasterID=@ID
 --select @billNo

DECLARE @fiscalid INT
SELECT @fiscalid=fyId FROM dbo.RO_fiscalYear WHERE (StartDate <= @BillDate) AND ( EndDate >= @BillDate)

Declare @username varchar(150)
select @username=UserName from  RO_OrderMasters where OrderMasterID=@ID
  
if not exists (Select salesMasterId from RO_SalesMaster where OrderMasterID =@ID)
    begin

	INSERT INTO dbo.RO_SalesMaster
        ( FiscalYearID,
          billNo ,
          BillDate ,
          RoomId ,
          TableId ,
          BasicAmount ,
          TermAmount ,
          NetAmount ,
          OrderMasterId ,
          Waiter

        )
VALUES  ( 
			@fiscalid,
			@billNo ,
			@BillDate ,
			@RoomId ,
			@TableId ,
			@BasicAmount ,
			@TermAmount ,
			@NetAmount ,
			@ID,
			@username
			
        )
		declare @Identity int
UPDATE RO_OrderMasters SET BillPaid = 1 WHERE OrderMasterID = @ID

	 SELECT @Identity = @@IDENTITY	 
end
   Insert into RO_SalesDetail 
   select @Identity,ItemId,Quantity,Rate,Amount,NetAmount,CostCenterId,0 from RO_Order_Detail
   where OrderMasterId=@ID
   UPDATE RO_OrderMasters SET BillPaid = 1 WHERE OrderMasterID = @ID
		end
		
--Select * from RO_SalesDetail order by 1 desc
--select * from RO_SalesMaster order by 1 desc
--select * from RO_Order_Detail order by 1 desc




GO
