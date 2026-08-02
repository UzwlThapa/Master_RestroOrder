SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--USP_RO_BILLTERM 700
--[dbo].[USP_RO_BILLTERM] 1500
CREATE PROCEDURE [dbo].[USP_RO_BILLTERM]
@amount decimal(18,2)
AS
BEGIN
DECLARE @BillTerm TABLE(
BillTerm VARCHAR(200),
Rate decimal(18,0),
Amount decimal(18,2),
IsAdd bit
)
--select Name, Rate, (Rate/100*@amount) as Value
--FROM  RO_BillTerm 
--ORDER BY SequenceOrder
DECLARE @Net_Amount Decimal(18,2)
DECLARE @Name VARCHAR(200), @Rate int ,@SequenceOrder int, @IsAdd bit

SET @Net_Amount=@amount
DECLARE cur CURSOR 
	FOR
	SELECT BT.Name,BT.Rate,BT.SequenceOrder,BT.IsAdd FROM dbo.RO_BillTerm BT ORDER BY BT.SequenceOrder
	OPEN cur	
	FETCH NEXT FROM cur	
	INTO @Name,@Rate,@SequenceOrder,@IsAdd
	WHILE @@FETCH_STATUS=0
	BEGIN
		
		
		INSERT INTO @BillTerm(BillTerm,Rate,Amount,IsAdd)
		VALUES(@Name,@Rate,((@Rate*@Net_Amount)/100),@IsAdd)

		SELECT @Net_Amount=CASE WHEN @IsAdd=0 THEN @Net_Amount-(@Rate*@Net_Amount)/100 ELSE @Net_Amount+(@Rate*@Net_Amount)/100 END

		FETCH NEXT FROM cur	INTO  @Name,@Rate,@SequenceOrder,@IsAdd	
	END
	CLOSE cur
	DEALLOCATE cur
	INSERT INTO @BillTerm(BillTerm,Rate,Amount)
		VALUES('NetAmount',0.00,@Net_Amount)
		
	SELECT bt.BillTerm,bt.Rate,bt.Amount,ISNULL(bt.IsAdd,1) as IsAdd FROM @BillTerm bt
end




GO
