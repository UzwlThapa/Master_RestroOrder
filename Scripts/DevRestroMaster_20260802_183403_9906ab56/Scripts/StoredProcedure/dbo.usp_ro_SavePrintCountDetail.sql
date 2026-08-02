SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_ro_SavePrintCountDetail]    
@Printcount INT     
,@BillNo NVARCHAR(max)    
,@PrintedBy NVARCHAR(max)    
,@SalesType NVARCHAR(20) = ''   
AS    
declare @Date datetime = getdate();
IF(ISNULL(@SalesType, '') = '')
BEGIN
 UPDATE dbo.RO_SalesMaster SET PrintCount = ISNULL(PrintCount,0)+1, PrintDate = @Date WHERE salesMasterId = @BillNo     
 INSERT INTO dbo.PrintDetail    
         ( PrintBillNo ,    
           PrintedNumber ,    
           PrintedDate ,    
           PrintedBy    
         )    
 VALUES  ( @BillNo, -- PrintBillNo - nvarchar(max)    
           @Printcount , -- PrintedNumber - int    
           @Date , -- PrintedDate - datetime    
          @PrintedBy  -- PrintedBy - nvarchar(max)    
         ) 

END
ELSE
BEGIN
UPDATE dbo.RO_CakeSalesMaster SET PrintCount = ISNULL(PrintCount,0)+1, PrintDate = @Date WHERE salesMasterId = @BillNo  
AND SalesType = @SalesType
 INSERT INTO Cake_PrintDetail    
         ( PrintBillNo ,    
           PrintedNumber ,    
           PrintedDate ,    
           PrintedBy,
		   SalesType    
         )    
 VALUES  ( @BillNo, -- PrintBillNo - nvarchar(max)    
           @Printcount , -- PrintedNumber - int    
           @Date , -- PrintedDate - datetime    
           @PrintedBy,  -- PrintedBy - nvarchar(max)    
		  @SalesType
         )    
END
	
	select	  Convert(nvarchar(120),@Date,120)


GO
