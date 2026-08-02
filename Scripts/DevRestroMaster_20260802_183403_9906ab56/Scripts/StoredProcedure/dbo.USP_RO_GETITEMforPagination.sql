SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--[dbo].[USP_RO_GETITEMforPagination]0,1 
CREATE PROCEDURE [dbo].[USP_RO_GETITEMforPagination] 
@offset INT
,@limit INT
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @RowTotal INT
	DECLARE @tblTemp TABLE (
		RowNum INT identity(1, 1)
		,ItemID int
		,ItemName varchar(128)
		,ItemDescription varchar(128)
		,PhotoPath varchar(128)
		,Price decimal(18, 2)
		,ItemCode varchar(128)
		,UnitName varchar(128)
		,CategoriesName varchar(128)
		)


	DECLARE @tblTemp1 TABLE (
		RowNum INT
		,ItemID int
		,ItemName varchar(128)
		,ItemDescription varchar(128)
		,PhotoPath varchar(128)
		,Price decimal(18, 2)
		,ItemCode varchar(128)
		,UnitName varchar(128)
		,CategoriesName varchar(128)
		)

	
	--select RO_Items.ItemID, RO_Items.ItemName, 
	--RO_Items.ItemDescription, dbo.RO_Items.PhotoPath, 
	--dbo.RO_Items.Price, RO_Items.ItemCode,   RO_Units.UnitName, 
	--dbo.RO_Categories.CategoriesName FROM dbo.RO_Items join RO_Units 
	--ON RO_Items.UnitID = RO_Units.UnitID  
	--JOIN dbo.RO_Categories ON dbo.RO_Categories.CategoriesID = RO_Items.CategoryID


INSERT INTO @tblTemp
	SELECT c.ItemID
		,c.ItemName
		,c.ItemDescription
		,c.PhotoPath
		,c.Price
		,c.ItemCode
		,f.UnitName
		,r.CategoriesName
	FROM dbo.RO_Items c
	JOIN RO_Units f ON c.UnitID = f.UnitID
	JOIN dbo.RO_Categories r ON r.CategoriesID = c.CategoryID
	ORDER BY ItemID

	DECLARE @counter INT

	SELECT @RowTotal = COUNT(ItemID)
	FROM @tblTemp

	SET @counter = 1

	WHILE (
			@counter <= @RowTotal
			OR @counter = 0
			)
	BEGIN
		DECLARE
		     @ItmID int
		    ,@ItmName varchar(128)
		    ,@ItmDescription varchar(128)
		    ,@PhotPath varchar(128)
		    ,@Pric decimal(18, 2)
		    ,@ItmCode varchar(128)
		    ,@UntName varchar(128)
		    ,@CtgName varchar(128)
			,@rnm INT
			,@rnm1 INT

		SELECT @ItmID = ItemID
		FROM @tblTemp
		WHERE RowNum = @counter

		SELECT @ItmName = ItemName
		FROM @tblTemp
		WHERE RowNum = @counter

		SELECT @ItmDescription = ItemDescription
		FROM @tblTemp
		WHERE RowNum = @counter

		SELECT @PhotPath= PhotoPath
		FROM @tblTemp
		WHERE RowNum = @counter

		SELECT @Pric = Price
		FROM @tblTemp
		WHERE RowNum = @counter

		SELECT @ItmCode = ItemCode
		FROM @tblTemp
		WHERE RowNum = @counter

		SELECT @UntName = UnitName
		FROM @tblTemp
		WHERE RowNum = @counter

		SELECT @CtgName = CategoriesName
		FROM @tblTemp
		WHERE RowNum = @counter

		IF (
				NOT EXISTS (
					SELECT ItemID
					FROM @tblTemp1
					WHERE ItemID = @ItmID
					)
				)
		BEGIN
			IF (
					(
						SELECT COUNT(ItemID)
						FROM @tblTemp1
						) > 0
					)
			BEGIN
				SELECT @rnm1 = MAX(RowNum)
				FROM @tblTemp1

				SET @rnm1 = @rnm1 + 1
			END
			ELSE
			BEGIN
				SET @rnm1 = 1
			END

			INSERT INTO @tblTemp1
			SELECT @rnm1
				,@ItmID 
				,@ItmName
				,@ItmDescription
				,@PhotPath 
				,@Pric 
				,@ItmCode 
				,@UntName 
				,@CtgName 
				
		END
		ELSE
		BEGIN
			SELECT @rnm = RowNum
			FROM @tblTemp1
			WHERE ItemID = @ItmID

			INSERT INTO @tblTemp1
			SELECT @rnm
				,@ItmID 
				,@ItmName
				,@ItmDescription
				,@PhotPath 
				,@Pric 
				,@ItmCode 
				,@UntName 
				,@CtgName 
		END

		SET @counter = @counter + 1
	END

	SELECT @RowTotal AS RowTotal
		,*
	FROM @tblTemp1
	WHERE RowNum >= @offset
		AND RowNum <= (@offset + @limit - 1)
END






GO
