SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[RPT_CustomerAgingReport]
 @ReportDate DATETIME, @MemberID int
 AS
BEGIN
IF (OBJECT_ID('tempdb..#TempTable') is not null)
drop table #TempTable
--SELECT @ReportDate=getdate(),@MemberID=295
SELECT  spm.CusID AS CustomerID,  spm.Customer AS CustomerName,  spm.salesPaymentID,  spm.PayAmount,cast(sm.BillDate as Date) as BillDate,0 as IsPaid
into  #TempTable
FROM            RO_SalesPaymentMode AS spm INNER JOIN
                         RO_SalesMaster AS sm ON sm.salesMasterId = spm.salesMasterId and sm.salesMasterId=spm.salesMasterId
WHERE   1=1 
AND  (spm.CusID = @MemberID) 
AND (spm.paymentModeID = 4) 
Order by sm.BillDate

--select * from #TempTable

declare  @Balance  decimal(10,2) 

select @Balance=sum(PayAmount) from RO_MemberPaymentMode where MemberID= @MemberID

declare @salesPaymentID INT, @PayAmount decimal(10,2)

Declare cur_payment cursor for
select salesPaymentID, PayAmount from #TempTable

OPEN cur_payment  
FETCH NEXT FROM cur_payment INTO @salesPaymentID, @PayAmount 

WHILE @@FETCH_STATUS = 0  
BEGIN  
     
	 If @Balance>= @PayAmount AND @Balance>0
	 BEGIN
		UPDATE #TempTable SET IsPaid=1 WHERE salesPaymentID=@salesPaymentID
		set @Balance=@Balance-@PayAmount
	END
	ELSE IF @Balance>0 AND @Balance<@PayAmount
	BEGIN
		UPDATE  #TempTable SET PayAmount=@PayAmount-@Balance WHERE salesPaymentID=@salesPaymentID
		set @Balance=0
	END

    FETCH NEXT FROM cur_payment INTO @salesPaymentID, @PayAmount 
END 

CLOSE cur_payment  
DEALLOCATE cur_payment 

--select * from #TempTable

--select CusID
--,CustomerName , sum(isnull(PayAmount,0))
-- from #TempTable 
-- where BillDate >= cast(DATEADD(day, -30, getdate())as Date)
-- group by CusID,CustomerName

DECLARE @CustomerAgingTable TABLE(
CustomerID INT,
CustomerName VARCHAR(250),
salesPaymentIDs VARCHAR(2000),
LessThan30 decimal(10,2),
Between30To60 decimal(10,2),
Between60To90 decimal(10,2),
GreaterThan90 decimal(10,2)
)

INSERT INTO @CustomerAgingTable(CustomerID, CustomerName, salesPaymentIDs, LessThan30)
select CustomerID,CustomerName, STUFF((
    SELECT ', ' + cast(salesPaymentID as varchar(50))
    FROM #TempTable 
    WHERE (CustomerID = vat.CustomerID) 
 and IsPaid=0 AND BillDate >= cast(DATEADD(day, -30, @ReportDate)as Date)
    FOR XML PATH(''),TYPE).value('(./text())[1]','VARCHAR(MAX)')
  ,1,2,'') AS salesPaymentIDs,
  SUM(PayAmount)
 from #TempTable vat
 where BillDate >= cast(DATEADD(day, -30, @ReportDate)as Date) and IsPaid=0
 group by CustomerID,CustomerName, BillDate, salesPaymentID

 
INSERT INTO @CustomerAgingTable(CustomerID, CustomerName, salesPaymentIDs, Between30To60)
select CustomerID,CustomerName, STUFF((
    SELECT ', ' +  cast(salesPaymentID as varchar(50))
    FROM #TempTable 
    WHERE (CustomerID = vat.CustomerID) 
 and IsPaid=0 and  BillDate < cast(DATEADD(day, -30, @ReportDate)as Date) 
 and  BillDate >= cast(DATEADD(day, -60, @ReportDate)as Date) 
    FOR XML PATH(''),TYPE).value('(./text())[1]','VARCHAR(MAX)')
  ,1,2,'') AS salesPaymentIDs, 
  SUM(PayAmount)
 from #TempTable vat
 where BillDate < cast(DATEADD(day, -30, @ReportDate)as Date) 
 and  BillDate >= cast(DATEADD(day, -60, @ReportDate)as Date) 
 and IsPaid=0
 group by CustomerID,CustomerName, BillDate, salesPaymentID

 

 
INSERT INTO @CustomerAgingTable(CustomerID, CustomerName, salesPaymentIDs, Between60To90)
select CustomerID,CustomerName, STUFF((
    SELECT ', ' +  cast(salesPaymentID as varchar(50))
    FROM #TempTable 
    WHERE (CustomerID = vat.CustomerID) 
 and IsPaid=0 and BillDate < cast(DATEADD(day, -60, @ReportDate)as Date)  and  BillDate >= cast(DATEADD(day, -90, @ReportDate)as Date) 
    FOR XML PATH(''),TYPE).value('(./text())[1]','VARCHAR(MAX)')
  ,1,2,'') AS salesPaymentIDs,
  SUM(PayAmount)
 from #TempTable vat
 where BillDate < cast(DATEADD(day, -60, @ReportDate)as Date)  and  BillDate >= cast(DATEADD(day, -90, @ReportDate)as Date) 
 and IsPaid=0
 group by CustomerID,CustomerName, BillDate, salesPaymentID

  
INSERT INTO @CustomerAgingTable(CustomerID, CustomerName, salesPaymentIDs, GreaterThan90)
select CustomerID,CustomerName, STUFF((
    SELECT ', ' +  cast(salesPaymentID as varchar(50))
    FROM #TempTable 
    WHERE (CustomerID = vat.CustomerID) 
 and IsPaid=0 and 
 BillDate < cast(DATEADD(day, -90, @ReportDate)as Date) 
    FOR XML PATH(''),TYPE).value('(./text())[1]','VARCHAR(MAX)')
  ,1,2,'') AS salesPaymentIDs,
  SUM(PayAmount)
 from #TempTable vat
 where BillDate < cast(DATEADD(day, -90, @ReportDate)as Date) 
 and IsPaid=0
 group by CustomerID,CustomerName, BillDate, salesPaymentID



 SELECT CustomerID, CustomerName, salesPaymentIDs
 ,sum(ISNULL(LessThan30,0)) LessThan30
 ,sum(ISNULL(Between30To60,0)) Between30To60
 ,sum(ISNULL(Between60To90,0)) Between60To90
 ,sum(ISNULL(GreaterThan90,0)) GreaterThan90 
 FROM @CustomerAgingTable
 GROUP BY CustomerID, CustomerName, salesPaymentIDs

 END


GO
