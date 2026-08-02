SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--     [USP_RO_BILLTERM_WITHID] 178,113
CREATE PROCEDURE [dbo].[USP_RO_BILLTERM_WITHID]     
@amount decimal(18,2)    ,
@SaleMasterID int
AS    
BEGIN    
DECLARE @BillTerm TABLE(    
ID int,    
BillTerm VARCHAR(200),    
Rate decimal(18,2),    
Amount decimal(18,2)  
--,rate decimal(18,2)  
)    
--select Name, Rate, (Rate/100*@amount) as Value    
--FROM  RO_BillTerm     
--ORDER BY SequenceOrder    
DECLARE @Net_Amount Decimal(18,2)    
DECLARE @Name VARCHAR(200), @Rate int ,@SequenceOrder int, @IsAdd bit    
Declare @ID int    
SET @Net_Amount=@amount    
DECLARE cur CURSOR     
 FOR    
 SELECT BT.BilingID, BT.Name,BT.Rate,BT.SequenceOrder,BT.IsAdd FROM dbo.RO_BillTerm BT ORDER BY BT.SequenceOrder    
 OPEN cur     
 FETCH NEXT FROM cur     
 INTO @ID, @Name,@Rate,@SequenceOrder,@IsAdd    
 WHILE @@FETCH_STATUS=0    
 BEGIN    
      
      
  INSERT INTO @BillTerm(ID,BillTerm,Rate,Amount)    
  VALUES(@ID, @Name,@Rate,((@Rate*@Net_Amount)/100))    
    
  SELECT @Net_Amount=CASE WHEN @IsAdd=0 THEN @Net_Amount-(@Rate*@Net_Amount)/100 ELSE @Net_Amount+(@Rate*@Net_Amount)/100 END    
    
  FETCH NEXT FROM cur INTO @ID, @Name,@Rate,@SequenceOrder,@IsAdd     
 END    
 CLOSE cur    
 DEALLOCATE cur    
 INSERT INTO @BillTerm(ID, BillTerm,Rate,Amount)    
  VALUES(1,'NetAmount',0.00,@Net_Amount)    
      
 SELECT * FROM @BillTerm   
 insert into RO_BillingAmount (BilingID,SalesMasterID,Amount,IsVoid,rate)
 select ID,@SaleMasterID,Amount,0,Rate from @BillTerm
end




GO
