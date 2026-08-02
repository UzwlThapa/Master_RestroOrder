SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[USP_SAVEPURCHASEORDER] (  
 @OrderId INT  
 ,@ItemName NVARCHAR(256)
 ,@Quantity NVARCHAR(256) 
 )  
AS  
 BEGIN  
  INSERT INTO tblPurchaseOrder(  
 ItemName,
 Quantity,
 AddedOn
   )  
  VALUES (  
@ItemName,
@Quantity,
GETDATE()
   )   
SELECT @@IDENTITY  
END


GO
