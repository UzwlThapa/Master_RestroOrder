SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--     [SalesDetailsStore] 6861
CREATE PROCEDURE [dbo].[SalesDetailsStore]
	-- Add the parameters for the stored procedure here
	@OrderMasterID int,@SalesMasterID int

AS
BEGIN


select* from dbo.RO_SalesMaster

select* from dbo.RO_SalesDetail

select * from dbo.RO_Order_Detail
select * from dbo.RO_OrderMasters 

SELECT * from RO_Order_Detail where OrderMasterId = 6864
SELECT * from RO_SalesDetail 
--DECLARE @i int
----SELECT [OrderDetailsID] FROM [RestroOrderInventory_testMerge].[dbo].[RO_Order_Detail] where [OrderMasterId] = 6865
--  SET @i = 1
--while(@i<= (select count([OrderDetailsID]) from RO_Order_Detail where OrderMasterID=6861))
--BEGIN
--select top 2 OrderDetailsID,Quantity, Rate, Amount,ItemId,NetAmount,CostCenterId from RO_Order_Detail order by 1 desc
--set @i=@i+1
--END

END

--DECLARE @site_value INT;
--SET @site_value = 0;
--WHILE @site_value <= 10
--BEGIN
--   PRINT 'Inside WHILE LOOP on TechOnTheNet.com';
--   set @site_value=@site_value+1
--END;




GO
