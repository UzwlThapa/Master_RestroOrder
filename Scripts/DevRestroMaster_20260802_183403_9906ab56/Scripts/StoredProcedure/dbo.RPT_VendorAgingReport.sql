SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[RPT_VendorAgingReport]
  @ReportDate DATETIME, @MemberID int
AS
BEGIN
IF (OBJECT_ID('tempdb..#TempTable') is not null)
drop table #TempTable
--SELECT @ReportDate=getdate(),@MemberID=34
SELECT  ppm.VendorID,  ppm.VendorName,  ppm.GMId,  gm.GMNo, ppm.PayAmount,cast(gm.InvoiceDate as Date) as InvoiceDate,0 as IsPaid
into  #TempTable
FROM            RO_PurchasePaymentMode AS ppm INNER JOIN
                         RO_GoodsReceivedMain AS gm ON gm.GMId = ppm.GMId
WHERE   1=1 
AND     (gm.vendorId = @MemberID) 
AND (ppm.paymentModeID = 4) 
Order by gm.InvoiceDate

--select * from #TempTable

declare  @Balance  decimal(10,2) 

select @Balance=sum(PayAmount) from RO_MemberPaymentMode where MemberID= @MemberID

declare @GMId INT, @PayAmount decimal(10,2)

Declare cur_payment cursor for
select GMId, PayAmount from #TempTable

OPEN cur_payment  
FETCH NEXT FROM cur_payment INTO @GMId, @PayAmount 

WHILE @@FETCH_STATUS = 0  
BEGIN  
     
	 If @Balance>= @PayAmount AND @Balance>0
	 BEGIN
		UPDATE #TempTable SET IsPaid=1 WHERE GMId=@GMId
		set @Balance=@Balance-@PayAmount
	END
	ELSE IF @Balance>0 AND @Balance<@PayAmount
	BEGIN
		UPDATE  #TempTable SET PayAmount=@PayAmount-@Balance WHERE GMId=@GMId
		set @Balance=0
	END

    FETCH NEXT FROM cur_payment INTO @GMId, @PayAmount 
END 

CLOSE cur_payment  
DEALLOCATE cur_payment 

--select * from #TempTable

--select VendorID
--,VendorName , sum(isnull(PayAmount,0))
-- from #TempTable 
-- where InvoiceDate >= cast(DATEADD(day, -30, getdate())as Date)
-- group by VendorID,VendorName

DECLARE @VendorAgingTable TABLE(
VendorID INT,
VendorName VARCHAR(250),
GMIDs VARCHAR(2000),
GMNos VARCHAR(2000),
LessThan30 decimal(10,2),
Between30To60 decimal(10,2),
Between60To90 decimal(10,2),
GreaterThan90 decimal(10,2)
)

INSERT INTO @VendorAgingTable(VendorID, VendorName, GMIDs, GMNos,LessThan30)
select VendorID,VendorName, STUFF((
    SELECT ', ' + cast(GMId as varchar(50))
    FROM #TempTable 
    WHERE (VendorId = vat.VendorId) 
 and IsPaid=0 AND InvoiceDate >= cast(DATEADD(day, -30, @ReportDate)as Date)
    FOR XML PATH(''),TYPE).value('(./text())[1]','VARCHAR(MAX)')
  ,1,2,'') AS GMIDs, STUFF((
    SELECT ', ' + GMNo
    FROM #TempTable 
    WHERE (VendorId = vat.VendorId) 
 and IsPaid=0 AND InvoiceDate >= cast(DATEADD(day, -30, @ReportDate)as Date)
    FOR XML PATH(''),TYPE).value('(./text())[1]','VARCHAR(MAX)')
  ,1,2,'') AS GMNos,
  SUM(PayAmount)
 from #TempTable vat
 where InvoiceDate >= cast(DATEADD(day, -30, @ReportDate)as Date) and IsPaid=0
 group by VendorID,VendorName, InvoiceDate, GMId

 
INSERT INTO @VendorAgingTable(VendorID, VendorName, GMIDs, GMNos,Between30To60)
select VendorID,VendorName, STUFF((
    SELECT ', ' +  cast(GMId as varchar(50))
    FROM #TempTable 
    WHERE (VendorId = vat.VendorId) 
 and IsPaid=0 AND InvoiceDate < cast(DATEADD(day, -30, @ReportDate)as Date) 
 and  InvoiceDate >= cast(DATEADD(day, -60, @ReportDate)as Date) 
    FOR XML PATH(''),TYPE).value('(./text())[1]','VARCHAR(MAX)')
  ,1,2,'') AS GMIDs, 
  STUFF((
    SELECT ', ' + GMNo
    FROM #TempTable 
    WHERE (VendorId = vat.VendorId) 
 and IsPaid=0 AND InvoiceDate < cast(DATEADD(day, -30, @ReportDate)as Date) 
 and  InvoiceDate >= cast(DATEADD(day, -60, @ReportDate)as Date) 
    FOR XML PATH(''),TYPE).value('(./text())[1]','VARCHAR(MAX)')
  ,1,2,'') AS GMNos,
  SUM(PayAmount)
 from #TempTable vat
 where InvoiceDate < cast(DATEADD(day, -30, @ReportDate)as Date) 
 and  InvoiceDate >= cast(DATEADD(day, -60, @ReportDate)as Date) 
 and IsPaid=0
 group by VendorID,VendorName, InvoiceDate, GMId

 

 
INSERT INTO @VendorAgingTable(VendorID, VendorName, GMIDs, GMNos,Between60To90)
select VendorID,VendorName, STUFF((
    SELECT ', ' +  cast(GMId as varchar(50))
    FROM #TempTable 
    WHERE (VendorId = vat.VendorId) 
 and IsPaid=0 and  InvoiceDate < cast(DATEADD(day, -60, @ReportDate)as Date)  and  InvoiceDate >= cast(DATEADD(day, -90, @ReportDate)as Date) 
    FOR XML PATH(''),TYPE).value('(./text())[1]','VARCHAR(MAX)')
  ,1,2,'') AS GMIDs, STUFF((
    SELECT ', ' + GMNo
    FROM #TempTable 
    WHERE (VendorId = vat.VendorId) 
		and IsPaid=0 and  InvoiceDate < cast(DATEADD(day, -60, @ReportDate)as Date)  and  InvoiceDate >= cast(DATEADD(day, -90, @ReportDate)as Date) 
    FOR XML PATH(''),TYPE).value('(./text())[1]','VARCHAR(MAX)')
  ,1,2,'') AS GMNos,
  SUM(PayAmount)
 from #TempTable vat
 where InvoiceDate < cast(DATEADD(day, -60, @ReportDate)as Date)  and  InvoiceDate >= cast(DATEADD(day, -90, @ReportDate)as Date) 
 and IsPaid=0
 group by VendorID,VendorName, InvoiceDate, GMId

  
INSERT INTO @VendorAgingTable(VendorID, VendorName, GMIDs, GMNos,GreaterThan90)
select VendorID,VendorName, STUFF((
    SELECT ', ' +  cast(GMId as varchar(50))
    FROM #TempTable 
    WHERE (VendorId = vat.VendorId) 
 and IsPaid=0 and InvoiceDate < cast(DATEADD(day, -90, @ReportDate)as Date) 
    FOR XML PATH(''),TYPE).value('(./text())[1]','VARCHAR(MAX)')
  ,1,2,'') AS GMIDs, STUFF((
    SELECT ', ' + GMNo
    FROM #TempTable 
    WHERE (VendorId = vat.VendorId) 
		and IsPaid=0 and InvoiceDate < cast(DATEADD(day, -90, @ReportDate)as Date) 
    FOR XML PATH(''),TYPE).value('(./text())[1]','VARCHAR(MAX)')
  ,1,2,'') AS GMNos,
  SUM(PayAmount)
 from #TempTable vat
 where InvoiceDate < cast(DATEADD(day, -90, @ReportDate)as Date) 
 and IsPaid=0
 group by VendorID,VendorName, InvoiceDate, GMId




 SELECT VendorID, VendorName, GMIDs, GMNos
 ,sum(ISNULL(LessThan30,0)) LessThan30
 ,sum(ISNULL(Between30To60,0)) Between30To60
 ,sum(ISNULL(Between60To90,0)) Between60To90
 ,sum(ISNULL(GreaterThan90,0)) GreaterThan90 
 FROM @VendorAgingTable
 GROUP BY VendorID, VendorName, GMIDs, GMNos

 END

GO
