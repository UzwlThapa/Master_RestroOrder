SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--[usp_ro_saveflatandPerdiscount] 0,'012.5','5.5','',1,0,'0','0','0'
--Drop PROC [dbo].[usp_ro_saveflatandPerdiscount]
CREATE PROCEDURE [dbo].[usp_ro_saveflatandPerdiscount] @SalesMasterId INT
	,@kotdis VARCHAR(128)
	,@bardis VARCHAR(128)
	,@roomdis VARCHAR(128)
	,@isflatdis BIT
	,@isloyalty BIT
	,@loyaltydis VARCHAR(128)
	,@bakerydis VARCHAR(128) = 0
	,@pizzadis VARCHAR(128) = 0
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
			,kotdis
			,bardis
			,isflatdis
			,isLoyalty
			,loyaltydis
			,roomdis
			,bakerydis
			,pizzadis
			)
		VALUES (
			@SalesMasterId
			,CASE 
				WHEN @kotdis = ''
					THEN '0'
				ELSE @kotdis
				END
			,CASE 
				WHEN @bardis = ''
					THEN '0'
				ELSE @bardis
				END
			,@isflatdis
			,@isloyalty
			,CASE 
				WHEN @loyaltydis = ''
					THEN '0'
				ELSE @loyaltydis
				END
			,CASE 
				WHEN @roomdis = ''
					THEN '0'
				ELSE @roomdis
				END
			,CASE 
				WHEN @bakerydis = ''
					THEN '0'
				ELSE @bakerydis
				END
			,CASE 
				WHEN @pizzadis = ''
					THEN '0'
				ELSE @pizzadis
				END
			)
	END
	ELSE
	BEGIN
		UPDATE dbo.ro_flatandPerDiscount
		SET SalesMasterId = @SalesMasterId
			,kotdis = @kotdis
			,bardis = @bardis
			,isflatdis = @isflatdis
			,isLoyalty = @isloyalty
			,loyaltydis = @loyaltydis
			,roomdis = @roomdis
			,bakerydis = @bakerydis
			,pizzadis = @pizzadis
		WHERE pfdId = @flId
	END
END

GO
