SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[USP_CreateSToreMinimumStock]
 @ItemId INT
	,@StoreId INT
	,@Unit INT
	,@Value INT

AS
  if((select count(*) from StoreItemMinimumStock where ItemId=@ItemId and StoreId = @StoreId) > 0) 
BEGIN
	UPDATE StoreItemMinimumStock set
	Unit=@Unit,
	Value= @Value,
	AddedOn=GETDATE()	
	Where ItemId=@ItemId and 
	StoreId=@StoreId

END
ELSE 
BEGIN

	INSERT INTO StoreItemMinimumStock (
	ItemId,
	StoreId,
	Unit,
	Value,
	AddedOn
		)
	VALUES (
		@ItemId,
		@StoreId,
		@Unit,
		@Value
		,GETDATE()		
		)	
	END

GO
