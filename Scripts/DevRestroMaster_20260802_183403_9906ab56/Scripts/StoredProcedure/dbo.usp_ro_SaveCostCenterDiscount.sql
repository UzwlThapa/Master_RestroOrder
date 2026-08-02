SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Drop PROC [dbo].[usp_ro_saveflatandPerdiscount]
CREATE PROCEDURE [dbo].[usp_ro_SaveCostCenterDiscount] 
	@SalesMasterId INT
	,@GroupId INT
	,@TotalAmt DECIMAL(15,2)
	,@TotalDis DECIMAL(15,2)
	,@isflatdis BIT
	,@isloyalty BIT
	,@loyaltydis VARCHAR(128)
	,@roomdis VARCHAR(128)
AS
BEGIN
	DECLARE @flId INT

	SELECT @flId = pfdId
	FROM ro_flatandPerDiscount
	WHERE SalesMasterId = @SalesMasterId

	IF (@flId IS NULL)
	BEGIN
		INSERT INTO dbo.ro_flatandPerDiscount (
			SalesMasterId
			,isflatdis
			,isLoyalty
			,loyaltydis
			,kotAmt
			,kotdis
			,[barAmt]
			,[bardis]
			,[roomAmt]
			,[roomdis]
			,[bakeryAmt]
			,[bakerydis]
			,[pizzaAmt]
			,[pizzadis]
			,[tradingAmt]
			,[tradingDis]
			)
		VALUES (
			@SalesMasterId
			,@isflatdis
			,@isloyalty
			,CASE 
				WHEN @loyaltydis = ''
					THEN '0'
				ELSE @loyaltydis
				END
			,CASE 
				WHEN @GroupId = 1
					THEN @TotalAmt
				ELSE 0
				END
			,CASE 
				WHEN @GroupId = 1
					THEN @TotalDis
				ELSE 0
				END
			,CASE 
				WHEN @GroupId = 2
					THEN @TotalAmt
				ELSE 0
				END
			,CASE 
				WHEN @GroupId = 2
					THEN @TotalDis
				ELSE 0
				END
			,0
			,@roomdis
			,CASE 
				WHEN @GroupId = 3
					THEN @TotalAmt
				ELSE 0
				END
			,CASE 
				WHEN @GroupId = 3
					THEN @TotalDis
				ELSE 0
				END
			,0
			,0
			,CASE 
				WHEN @GroupId = 4
					THEN @TotalAmt
				ELSE 0
				END
			,CASE 
				WHEN @GroupId = 4
					THEN @TotalDis
				ELSE 0
				END
			)
	END
	ELSE
	BEGIN
	IF(@GroupId = 1)
	BEGIN
	UPDATE dbo.ro_flatandPerDiscount
		SET SalesMasterId = @SalesMasterId
			,isflatdis = @isflatdis
			,isLoyalty = @isloyalty
			,loyaltydis = @loyaltydis
			,kotAmt = @TotalAmt
			,kotdis = @TotalDis
			WHERE pfdId = @flId
	END
	ELSE IF(@GroupId = 2)
	BEGIN
	UPDATE dbo.ro_flatandPerDiscount
		SET SalesMasterId = @SalesMasterId
			,isflatdis = @isflatdis
			,isLoyalty = @isloyalty
			,loyaltydis = @loyaltydis
			,barAmt = @TotalAmt
			,bardis = @TotalDis
			WHERE pfdId = @flId
	END
	ELSE IF(@GroupId = 3)
	BEGIN
	UPDATE dbo.ro_flatandPerDiscount
		SET SalesMasterId = @SalesMasterId
			,isflatdis = @isflatdis
			,isLoyalty = @isloyalty
			,loyaltydis = @loyaltydis
			,bakeryAmt = @TotalAmt
			,bakerydis = @TotalDis
			WHERE pfdId = @flId
	END
	ELSE IF(@GroupId = 4)
	BEGIN
	UPDATE dbo.ro_flatandPerDiscount
		SET SalesMasterId = @SalesMasterId
			,isflatdis = @isflatdis
			,isLoyalty = @isloyalty
			,loyaltydis = @loyaltydis
			,tradingAmt = @TotalAmt
			,tradingDis = @TotalDis
			WHERE pfdId = @flId
	END
	ELSE IF(@roomdis <> 0)
	BEGIN
	UPDATE dbo.ro_flatandPerDiscount
		SET SalesMasterId = @SalesMasterId
			,isflatdis = @isflatdis
			,isLoyalty = @isloyalty
			,loyaltydis = @loyaltydis
			,roomdis = @roomdis
			WHERE pfdId = @flId
	END
		
			
			
		
	END
END

GO
