SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE FUNCTION [dbo].[BillTerm] 
(
	@amount decimal(18,2)
)
RETURNS @BillTerm TABLE(
BillTerm VARCHAR(200),
Rate decimal(18,2),
Amount decimal(18,2)
)WITH EXECUTE AS CALLER
AS
BEGIN
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
		VALUES('NetAmount',0.00,@Net_Amount)
		
	
	
	RETURN 
END





GO
