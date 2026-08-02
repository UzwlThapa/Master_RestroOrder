SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_getdatabyBest]
as
begin

DECLARE @Temp table (
Temptableid int identity(1,1) primary key,
WaiterbyDays varchar(50),
TablebyDays varchar(50),
RoombyDays varchar(50),
ItembyDays varchar(50),

WaiterbyWeek varchar(50),
TablebyWeek varchar(50),
RoombyWeek varchar(50),
ItembyWeek varchar(50),

WaiterbyMonth varchar(50),
TablebyMonth varchar(50),
RoombyMonth varchar(50),
ItembyMonth varchar(50),

WaiterbyYear varchar(50),
TablebyYear varchar(50),
RoombyYear varchar(50),
ItembyYear varchar(50)
)

 
DECLARE @WaiterbyDays varchar(50)
DECLARE @TablebyDays varchar(50)
DECLARE @RoombyDays varchar(50)
DECLARE @ItembyDays varchar(50)
					  
DECLARE @WaiterbyWeek varchar(50)
DECLARE @TablebyWeek  varchar(50)
DECLARE @RoombyWeek   varchar(50)
DECLARE @ItembyWeek   varchar(50)

DECLARE @WaiterbyMonth varchar(50)
DECLARE @TablebyMonth  varchar(50)
DECLARE @RoombyMonth   varchar(50)
DECLARE @ItembyMonth   varchar(50)

DECLARE @WaiterbyYear  varchar(50)
DECLARE @TablebyYear   varchar(50)
DECLARE @RoombyYear    varchar(50)
DECLARE @ItembyYear    varchar(50)
-------select by Day------------------------------

SET @WaiterbyDays=(
select Distinct Waiter
from RO_SalesMaster 
--where  cast(BillDate as date) =  convert(varchar(10), getdate(),102)
where DATEPART(dd,BillDate) = DATEPART(dd,getdate())
AND BasicAmount=(SELECT max(BasicAmount) from RO_SalesMaster 
where  cast(BillDate as date) =  convert(varchar(10), getdate(),102))
)
SET @TablebyDays=(
	SELECT DISTINCT rt.restrotableTitle +','
	from RO_SalesMaster sm 
	left join RO_restroTable  rt on rt.restrotableId = sm.TableId  
	--where  cast(BillDate as date) = convert(varchar(10), getdate(),102)
	where DATEPART(dd,BillDate) = DATEPART(dd,getdate())
	AND BasicAmount=(SELECT max(BasicAmount) from RO_SalesMaster 
	where  cast(BillDate as date) = convert(varchar(10), getdate(),102))
	FOR XML PATH('')
)


DECLARE @reult INT 
SELECT TOP(1) @reult= RoomId FROM RO_SalesMaster 
WHERE  cast(BillDate as date) = convert(varchar(10), getdate(),102)
GROUP BY RoomId
ORDER BY SUM(BasicAmount) desc


SELECT @RoombyDays=restroRoom FROM RO_RestroRoom WHERE restroRoomId=@reult
--SET =(
 
--	--SELECT  rr.restroRoom 
--	--from RO_SalesMaster sm 
--	--left join RO_RestroRoom rr on rr.restroRoomId = sm.RoomId 
--	----where  cast(BillDate as date) = convert(varchar(10), getdate(),102)
--	--where DATEPART(dd,BillDate) = DATEPART(dd,getdate())
--	--AND BasicAmount=(SELECT max(BasicAmount) from RO_SalesMaster where  cast(BillDate as date) = convert(varchar(10), getdate(),102))
--	--GROUP BY rr.restroRoom 
--	--HAVING MAX(SUM(1)) = SUM(1)

	

--)

SET @ItembyDays=(
	SELECT DISTINCT ','+ i.ITName
	from RO_SalesMaster sm
	left join RO_SalesDetail sd on sd.salesMasterId = sm.salesMasterId 
	left join ROI_ITEMMain I ON I.ITId = sd.ItemId 
	--where  cast(BillDate as date) = convert(varchar(10), getdate(),102)
	where DATEPART(dd,BillDate) = DATEPART(dd,getdate())
	AND BasicAmount=(SELECT max(BasicAmount) from RO_SalesMaster 
	where  cast(BillDate as date) = convert(varchar(10), getdate(),102))
	FOR XML PATH('')
)

-------select by Week------------------------------

SET @WaiterbyWeek=(
SELECT Distinct Waiter 
FROM RO_SalesMaster
WHERE CONVERT(varchar(10),BillDate,102) BETWEEN CONVERT(varchar(10),DateAdd(DD,-7, GETDATE()),102) AND CONVERT(varchar(10),GETDATE(),102)
AND BasicAmount=(SELECT max(BasicAmount) from RO_SalesMaster 
where CONVERT(varchar(10),BillDate,102)  BETWEEN  CONVERT(varchar(10),DateAdd(DD,-7, GETDATE()),102) AND CONVERT(varchar(10),GETDATE(),102))
	
	)

SET @TablebyWeek=(
	select Distinct TOP 1 rt.restrotableTitle 
	from RO_SalesMaster sm 
	left join RO_restroTable  rt on rt.restrotableId = sm.TableId  
	WHERE CONVERT(varchar(10),BillDate,102) BETWEEN CONVERT(varchar(10),DateAdd(DD,-7, GETDATE()),102) AND CONVERT(varchar(10),GETDATE(),102)
	AND BasicAmount=(SELECT max(BasicAmount) from RO_SalesMaster 
	WHERE CONVERT(varchar(10),BillDate,102)  BETWEEN  CONVERT(varchar(10),DateAdd(DD,-7, GETDATE()),102) AND CONVERT(varchar(10),GETDATE(),102))
	)																		
																			
SET @RoombyWeek=(															
	select Distinct TOP 1 rr.restroRoom 											
	from RO_SalesMaster sm 													
	left join RO_RestroRoom rr on rr.restroRoomId = sm.RoomId 				
	WHERE CONVERT(varchar(10),BillDate,102) BETWEEN CONVERT(varchar(10),DateAdd(DD,-7, GETDATE()),102) AND CONVERT(varchar(10),GETDATE(),102)
	AND BasicAmount=(SELECT max(BasicAmount) from RO_SalesMaster 
	WHERE CONVERT(varchar(10),BillDate,102)  BETWEEN  CONVERT(varchar(10),DateAdd(DD,-7, GETDATE()),102) AND CONVERT(varchar(10),GETDATE(),102))
	)																		
																			
SET @ItembyWeek=(															
	select DISTINCT ','+ i.ItemName											
	from RO_SalesMaster sm													
	left join RO_SalesDetail sd on sd.salesMasterId = sm.salesMasterId 		
	left join RO_Items I ON I.ItemID = sd.ItemId 							
	WHERE CONVERT(varchar(10),BillDate,102) BETWEEN CONVERT(varchar(10),DateAdd(DD,-7, GETDATE()),102) AND CONVERT(varchar(10),GETDATE(),102)
	AND BasicAmount=(SELECT max(BasicAmount) from RO_SalesMaster 
	WHERE CONVERT(varchar(10),BillDate,102)  BETWEEN  CONVERT(varchar(10),DateAdd(DD,-7, GETDATE()),102) AND CONVERT(varchar(10),GETDATE(),102))
	FOR XML PATH('')
	)
-------------------------------------------------------------------------------------------------------
-------select by Month------------------------------

 
  
  
SET @WaiterbyMonth=(
	SELECT Distinct Waiter 
	FROM RO_SalesMaster 
	WHERE
	CAST(DATEPART(YEAR,BillDate) AS VARCHAR(128))+' '+CAST(DATEPART(MONTH,BillDate)AS VARCHAR(128))=CAST(DATEPART(YEAR,GETDATE()) AS VARCHAR(128))+' '+ CAST(DATEPART(MONTH,GETDATE())AS VARCHAR(128))
	AND BasicAmount=(SELECT max(BasicAmount) from RO_SalesMaster 	
	where CAST(DATEPART(YEAR,BillDate) AS VARCHAR(128))+' '+CAST(DATEPART(MONTH,BillDate)AS VARCHAR(128)) = CAST(DATEPART(YEAR,GETDATE()) AS VARCHAR(128))+' '+ CAST(DATEPART(MONTH,GETDATE())AS VARCHAR(128)))
	)
	SET @TablebyMonth=(
	select Distinct rt.restrotableTitle 
	from RO_SalesMaster sm 
	left join RO_restroTable  rt on rt.restrotableId = sm.TableId  
	WHERE
	CAST(DATEPART(YEAR,BillDate) AS VARCHAR(128))+' '+CAST(DATEPART(MONTH,BillDate)AS VARCHAR(128))=CAST(DATEPART(YEAR,GETDATE()) AS VARCHAR(128))+' '+ CAST(DATEPART(MONTH,GETDATE())AS VARCHAR(128))
	AND BasicAmount=(SELECT max(BasicAmount) from RO_SalesMaster 	
	where CAST(DATEPART(YEAR,BillDate) AS VARCHAR(128))+' '+CAST(DATEPART(MONTH,BillDate)AS VARCHAR(128)) = CAST(DATEPART(YEAR,GETDATE()) AS VARCHAR(128))+' '+ CAST(DATEPART(MONTH,GETDATE())AS VARCHAR(128)))
	)

	SET @RoombyMonth=(
	select Distinct rr.restroRoom 
	from RO_SalesMaster sm 
	left join RO_RestroRoom rr on rr.restroRoomId = sm.RoomId 
	WHERE	
	CAST(DATEPART(YEAR,BillDate) AS VARCHAR(128))+' '+CAST(DATEPART(MONTH,BillDate)AS VARCHAR(128))=CAST(DATEPART(YEAR,GETDATE()) AS VARCHAR(128))+' '+ CAST(DATEPART(MONTH,GETDATE())AS VARCHAR(128))
	AND BasicAmount=(SELECT max(BasicAmount) from RO_SalesMaster 	
	where CAST(DATEPART(YEAR,BillDate) AS VARCHAR(128))+' '+CAST(DATEPART(MONTH,BillDate)AS VARCHAR(128)) = CAST(DATEPART(YEAR,GETDATE()) AS VARCHAR(128))+' '+ CAST(DATEPART(MONTH,GETDATE())AS VARCHAR(128)))
	)


	SET @ItembyMonth=(
	select DISTINCT ','+ i.ItemName
	from RO_SalesMaster sm
	left join RO_SalesDetail sd on sd.salesMasterId = sm.salesMasterId 
	left join RO_Items I ON I.ItemID = sd.ItemId 
	WHERE
	CAST(DATEPART(YEAR,BillDate) AS VARCHAR(128))+' '+CAST(DATEPART(MONTH,BillDate)AS VARCHAR(128))=CAST(DATEPART(YEAR,GETDATE()) AS VARCHAR(128))+' '+ CAST(DATEPART(MONTH,GETDATE())AS VARCHAR(128))
	AND BasicAmount=(SELECT max(BasicAmount) from RO_SalesMaster 	
	where CAST(DATEPART(YEAR,BillDate) AS VARCHAR(128))+' '+CAST(DATEPART(MONTH,BillDate)AS VARCHAR(128)) = CAST(DATEPART(YEAR,GETDATE()) AS VARCHAR(128))+' '+ CAST(DATEPART(MONTH,GETDATE())AS VARCHAR(128)))
	FOR XML PATH('')
	)



	-------select by Year------------------------------


	SET @WaiterbyYear=(
	SELECT Distinct Waiter 
	FROM RO_SalesMaster 
	WHERE
	DATEPART(YEAR,BillDate) = DATEPART(YEAR, getdate())
	AND BasicAmount=(SELECT max(BasicAmount) from RO_SalesMaster 	
	where DATEPART(YEAR,BillDate) = DATEPART(YEAR,getdate()))
	
	)
	SET @TablebyYear=(
	select Distinct rt.restrotableTitle 
	from RO_SalesMaster sm 
	left join RO_restroTable  rt on rt.restrotableId = sm.TableId  
	WHERE
	DATEPART(YEAR,BillDate) = DATEPART(YEAR, getdate())
	AND BasicAmount=(SELECT max(BasicAmount) from RO_SalesMaster 	
	where DATEPART(YEAR,BillDate) = DATEPART(YEAR,getdate()))
	)

	SET @RoombyYear=(
	select Distinct rr.restroRoom 
	from RO_SalesMaster sm 
	left join RO_RestroRoom rr on rr.restroRoomId = sm.RoomId 
	WHERE
	DATEPART(YEAR,BillDate) = DATEPART(YEAR, getdate())
	AND BasicAmount=(SELECT max(BasicAmount) from RO_SalesMaster 	
	where DATEPART(YEAR,BillDate) = DATEPART(YEAR,getdate()))
	)


	SET @ItembyYear=(
	select Distinct ','+i.ItemName
	from RO_SalesMaster sm
	left join RO_SalesDetail sd on sd.salesMasterId = sm.salesMasterId 
	left join RO_Items I ON I.ItemID = sd.ItemId 
	WHERE
	DATEPART(YEAR,BillDate) = DATEPART(YEAR, getdate())
	AND BasicAmount=(SELECT max(BasicAmount) from RO_SalesMaster 	
	where DATEPART(YEAR,BillDate) = DATEPART(YEAR,getdate()))
	FOR XML PATH('')
	
	)

	 
	  
	   
	   

	
	-------------------------------------------------------------------------------------------------------------------

	INSERT INTO @Temp (
	WaiterbyDays,
	TablebyDays, 
	RoombyDays, 
	ItembyDays,

	WaiterbyWeek,
	TablebyWeek,
	RoombyWeek,
	ItembyWeek,

	WaiterbyMonth,
	TablebyMonth,
	RoombyMonth,
	ItembyMonth,

	WaiterbyYear,
	TablebyYear,
	RoombyYear,
	ItembyYear
	)
	 VALUES
	 (
		@WaiterbyDays, 
		@TablebyDays, 
		@RoombyDays, 
		@ItembyDays,

		@WaiterbyWeek,
		@TablebyWeek,
		@RoombyWeek,
		@ItembyWeek,

		@WaiterbyMonth,
		@TablebyMonth,
		@RoombyMonth,
		@ItembyMonth,

		@WaiterbyYear, 
		@TablebyYear,
		@RoombyYear, 
		@ItembyYear  
	)
SELECT * FROM @Temp
end







GO
