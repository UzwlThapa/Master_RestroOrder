SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[USP_RO_BILLTERM_NETAMOUNT] 
@amount decimal(18,2)
AS
BEGIN
DECLARE @BillTerm TABLE(
BillTerm VARCHAR(200),
Rate decimal(18,2),
Amount decimal(18,2)
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
		
		
		INSERT INTO @BillTerm(BillTerm,Rate,Amount)
		VALUES(@Name,@Rate,((@Rate*@Net_Amount)/100))

		SELECT @Net_Amount=CASE WHEN @IsAdd=0 THEN @Net_Amount-(@Rate*@Net_Amount)/100 ELSE @Net_Amount+(@Rate*@Net_Amount)/100 END

		FETCH NEXT FROM cur	INTO  @Name,@Rate,@SequenceOrder,@IsAdd	
	END
	CLOSE cur
	DEALLOCATE cur
	INSERT INTO @BillTerm(BillTerm,Rate,Amount)
		VALUES('Net Amount',0.00,@Net_Amount)
		
	SELECT distinct @Net_Amount as amount FROM @BillTerm 
	
end


GO
