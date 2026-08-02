SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 CREATE PROCEDURE [dbo].[USP_MemberAgingReport]
 as
 declare  @Date DATETIME
IF (OBJECT_ID('tempdb..#TempTable') is not null)
drop table #TempTable

SELECT  ppm.VendorID,  ppm.VendorName,  ppm.GMId,  gm.GMNo, ppm.PayAmount,cast(gm.InvoiceDate as Date) as InvoiceDate,0 as IsPaid
into  #TempTable
FROM            RO_PurchasePaymentMode AS ppm INNER JOIN
                         RO_GoodsReceivedMain AS gm ON gm.GMId = ppm.GMId
WHERE        (gm.vendorId = 26) AND (ppm.paymentModeID = 4) Order by gm.InvoiceDate

--select * from #TempTable

 declare  @Balance  decimal(10,2) 

  select @Balance=sum(PayAmount) from RO_MemberPaymentMode where MemberID= 26

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

select * from #TempTable

--select VendorID
--,VendorName , sum(isnull(PayAmount,0))
-- from #TempTable 
-- where InvoiceDate >= cast(DATEADD(day, -30, getdate())as Date)
-- group by VendorID,VendorName
select VendorID
,VendorName , InvoiceDate, GMId
 from #TempTable 
 where InvoiceDate >= cast(DATEADD(day, -30, getdate())as Date)
 group by VendorID,VendorName, InvoiceDate, GMId


 select VendorID
,VendorName 
,InvoiceDate
, GMId
--, sum(isnull(PayAmount,0))
 from #TempTable 
 where InvoiceDate <= cast(DATEADD(day, -30, getdate())as Date) and 
InvoiceDate >= cast(DATEADD(day, -60, getdate())as Date) 


 select VendorID
,VendorName 
,InvoiceDate
, GMId
--, sum(isnull(PayAmount,0))
 from #TempTable 
 where InvoiceDate <= cast(DATEADD(day, -60, getdate())as Date) and 
InvoiceDate >= cast(DATEADD(day, -90, getdate())as Date) 

 select VendorID
,VendorName 
,InvoiceDate
, GMId
--, sum(isnull(PayAmount,0))
 from #TempTable 
 where InvoiceDate <= cast(DATEADD(day, -90, getdate())as Date) 


  select VendorID
,VendorName 
,InvoiceDate
, GMId
--, sum(isnull(PayAmount,0))
 from #TempTable 
 where InvoiceDate >= cast(DATEADD(day, -90, getdate())as Date) 
-- and 
--InvoiceDate >= cast(DATEADD(day, -90, getdate())as Date) 


GO
