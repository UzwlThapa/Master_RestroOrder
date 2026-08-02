SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_ro_extraitemsave] @ExtraItemID int,
	@ExtraItem NVARCHAR(200)
	,@ExtraPrice DECIMAL(18, 2)
	,@IsActive BIT
	,@AddedBy NVARCHAR(250)
AS
IF (@ExtraItemID  = 0)
BEGIN
	INSERT INTO RO_ExtraItem (
		ExtraItem
		,ExtraPrice
		,IsActive
		,AddedOn
		,IsDeleted
		,AddedBy
		)
	VALUES (
		@ExtraItem
		,@ExtraPrice
		,@IsActive
		,GETDATE()
		,0
		,@AddedBy
		)
		
	SELECT @@IDENTITY
END
ELSE
BEGIN
	UPDATE RO_ExtraItem
	SET 
		ExtraItem = @ExtraItem,
		ExtraPrice = @ExtraPrice
		,IsActive = @IsActive
		,UpdatedBy = @AddedBy
		,UpdatedOn = GETDATE()
	WHERE ExtraItemID = @ExtraItemID

	SELECT @ExtraItemID
END

GO
