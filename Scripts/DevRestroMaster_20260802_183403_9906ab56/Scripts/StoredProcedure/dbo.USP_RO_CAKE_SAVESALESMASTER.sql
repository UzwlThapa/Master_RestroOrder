SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================  
-- Author:  <Saroj Kumar Chaudhary>  
-- Create date: <7-Jan-2021>  
-- Description: <Save Cake Order sales details>  
-- EXECUTE: [dbo].[USP_RO_CAKE_SAVESALESMASTER] 0  
-- =============================================  
CREATE PROCEDURE [dbo].[USP_RO_CAKE_SAVESALESMASTER] 
 @BillNo VARCHAR(128)  
 ,@BillDate DATETIME  
 ,@OrderMasterId INT 
 ,@CustomerId INT 
 ,@CustomerName varchar(200)  
 ,@ContactNumber varchar(200)
  ,@PAN NVARCHAR(250) = NULL 
  ,@Address NVARCHAR(250) = NULL  
 ,@BasicAmount DECIMAL(18, 2)   
 ,@TermAmount DECIMAL(18, 2)  
 ,@NetAmount DECIMAL(18, 2)  
 ,@AdvancePayment DECIMAL(18, 2)  
 ,@Reasons NVARCHAR(max)  
 ,@NepaliInvoiceDate NVARCHAR(max)  
 ,@AddedBy NVARCHAR(256)  
 ,@SalesType VARCHAR(30) = NULL
 ,@TenderAmount DECIMAL(18,2) = NULL
 ,@ReturnAmount DECIMAL(18,2) = NULL 
 
AS  
BEGIN  
 DECLARE @InvoiceNo INT = 0;  
 DECLARE @fiscalid INT  
  ,@firstsalesmasterid INT  
  
 SELECT @fiscalid = fyId  
  ,@firstsalesmasterid = FirstSalesMasterID  
 FROM dbo.RO_fiscalYear  
 WHERE (StartDate <= GETDATE())  
  AND (EndDate >= GETDATE())  

SELECT @InvoiceNo = CASE 
	WHEN @BillNo = '1234' 
	THEN MAX(InvoiceNo) 
	ELSE MAX(InvoiceNo) + 1 
	END 
FROM
(
SELECT MAX(InvoiceNo) InvoiceNo  FROM RO_SalesMaster
UNION
SELECT MAX(InvoiceNo) InvoiceNo  FROM RO_CakeSalesMaster
) t
  
 SET @InvoiceNo = isnull(@InvoiceNo, 1)  


 IF (@firstsalesmasterid IS NULL)  
 BEGIN  
  DECLARE @lastsalesmasterid INT  
  SET @lastsalesmasterid = @InvoiceNo;  
  
  UPDATE dbo.RO_fiscalYear  
  SET FirstSalesMasterID = @lastsalesmasterid  
  WHERE fyId = @fiscalid  
 END 

  
 INSERT INTO dbo.RO_CakeSalesMaster (  
  FiscalYearID
  ,BillNo  
  ,BillDate	
  ,OrderMasterId 
  ,CustomerId 
  ,CustomerName	
  ,ContactNo	
  ,PAN	
  ,Address	
  ,BasicAmount  
  ,TermAmount	
  ,NetAmount	
  ,AdvancePayment	
  ,TenderAmount	
  ,ReturnAmount	
  ,PrintCount	
  ,PrintDate	
  ,IsArchived	
  ,ArchivedBy	
  ,ArchivedOn	
  ,IsUpdated	
  ,UpdatedBy	
  ,UpdatedOn	
  ,Reasons	
  ,AddedBy	
  ,AddedOn	
  ,InvoiceNo	
  ,NepaliInvoiceDate  
  ,SalesType
  )  
 VALUES (  
  @fiscalid
  ,@billNo  
  ,getdate()  
  ,@OrderMasterId 
  ,@CustomerId
  ,@CustomerName
  ,@ContactNumber
  ,@PAN
  ,@Address  
  ,@BasicAmount   
  ,@TermAmount  
  ,@NetAmount  
  ,@AdvancePayment
  ,@TenderAmount
  ,@ReturnAmount
  ,1   
  ,GETDATE()  
  ,0
  ,NULL
  ,NULL
  ,0
  ,NULL
  ,NULL
  ,@Reasons
  ,@AddedBy  
  ,GETDATE()   
  ,@InvoiceNo 
  ,@NepaliInvoiceDate  
  ,@SalesType
  )  
  
 -- DECLARE @EmpLoginid INT    
 --EXEC @EmpLoginid = USP_RO_BILLTERM 200    
 SELECT @@IDENTITY  
  --DECLARE @id VARCHAR(128)    
  --SET @id = (select max(m.salesMasterId)    
  --FROM RO_SalesMaster m)    
  --select @id    
END  

GO
