SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_RO_GetSalesSummary] --'2017/01/13','1753/01/01',1,0,0,'2016/01/07','2016/01/08'
@Todaydate DATE,
@Weeklydate date,
@value INT ,
@month INT ,
@year INT,
@FromDate date,
@ToDate date 
AS
BEGIN
IF(@value = 1)
BEGIN

SELECT Oi.OrderDetailsID ,Oi.ROI_ItemId,Oi.Quantity,i.ItName,Om.BillNo, OM.BillPaid, cast(Om.Date as varchar(12)) as Date,ru.Symbol as ITUnit
	 FROM RO_Order_Detail Oi INNER JOIN
	 RO_OrderMasters Om  ON Om.OrderMasterID = Oi.OrderMasterId INNER JOIN 
	 dbo.ROI_ITEMMain i ON i.ITId = Oi.ROI_ItemId
	 left join ROI_ItemDetails itd on i.ITId=itd.ITId
	left join ROI_Unit1 ru on ru.Unit1Id=itd.SmallUnit
	 WHERE CAST(Om.Date AS date)=  @Todaydate AND OM.BillPaid = 1
	 --select *  FROM RO_Order_Detail

END
ELSE IF(@value = 2)
BEGIN
SELECT Oi.OrderDetailsID ,Oi.ROI_ItemId,Oi.Quantity,i.ItName,Om.BillNo, OM.BillPaid, cast(Om.Date as varchar(12)) as Date,ru.Symbol as ITUnit
	 FROM RO_Order_Detail Oi INNER JOIN  RO_OrderMasters Om  ON Om.OrderMasterID = Oi.OrderMasterId INNER JOIN 
	 dbo.ROI_ITEMMain i ON i.ITId = Oi.ROI_ItemId
	 left join ROI_ItemDetails itd on i.ITId=itd.ITId
	left join ROI_Unit1 ru on ru.Unit1Id=itd.SmallUnit
	  WHERE CAST(Om.Date AS date) BETWEEN DATEADD(d,-7,@Weeklydate) AND  @Weeklydate AND  Om.BillPaid =1

END
ELSE IF(@value = 3)
BEGIN
SELECT Oi.OrderDetailsID ,Oi.ROI_ItemId,Oi.Quantity,i.ItName,Om.BillNo, OM.BillPaid, cast(Om.Date as varchar(12)) as Date,ru.Symbol as ITUnit
	 FROM RO_Order_Detail Oi INNER JOIN  RO_OrderMasters Om  ON Om.OrderMasterID = Oi.OrderMasterId INNER JOIN 
	 dbo.ROI_ITEMMain i ON i.ITId = Oi.ROI_ItemId
	 left join ROI_ItemDetails itd on i.ITId=itd.ITId
	left join ROI_Unit1 ru on ru.Unit1Id=itd.SmallUnit
	  WHERE Month(Om.Date)=@month  AND  YEAR(Om.Date) = @year AND OM.BillPaid = 1

END
ELSE IF(@value = 4)
BEGIN
	 SELECT Oi.OrderDetailsID ,Oi.ROI_ItemId,Oi.Quantity,i.ItName,Om.BillNo, OM.BillPaid, cast(Om.Date as varchar(12)) as Date,ru.Symbol as ITUnit
	 FROM RO_Order_Detail Oi INNER JOIN  RO_OrderMasters Om  ON Om.OrderMasterID = Oi.OrderMasterId INNER JOIN 
	 dbo.ROI_ITEMMain i ON i.ITId = Oi.ROI_ItemId
	 left join ROI_ItemDetails itd on i.ITId=itd.ITId
	left join ROI_Unit1 ru on ru.Unit1Id=itd.SmallUnit
	  WHERE YEAR(Om.Date) = @year AND OM.BillPaid = 1
END
ELSE 
BEGIN

SELECT Oi.OrderDetailsID ,Oi.ROI_ItemId,Oi.Quantity,i.ItName,Om.BillNo, OM.BillPaid, cast(Om.Date as varchar(12)) as Date,ru.Symbol as ITUnit
	 FROM RO_Order_Detail Oi INNER JOIN  RO_OrderMasters Om  ON Om.OrderMasterID = Oi.OrderMasterId INNER JOIN 
	 dbo.ROI_ITEMMain i ON i.ITId = Oi.ROI_ItemId
	 left join ROI_ItemDetails itd on i.ITId=itd.ITId
	left join ROI_Unit1 ru on ru.Unit1Id=itd.SmallUnit
	  WHERE CAST(Om.Date AS date) BETWEEN @FromDate AND @ToDate AND OM.BillPaid = 1
END
END

--USP_RO_GetSalesSummary '11/24/2016','',1,'','','',''




	 

	 




GO
