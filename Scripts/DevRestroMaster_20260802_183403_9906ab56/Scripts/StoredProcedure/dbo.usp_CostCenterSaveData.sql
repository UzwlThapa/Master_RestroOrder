SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_CostCenterSaveData] @CostCenterId INT
	,@CostCenterName NVARCHAR(50)
	,@Username NVARCHAR(50)
	,@DefaultPrinter NVARCHAR(50)
	,@coDiscount DECIMAL(8, 2)
	,@NumberOfCounter INT
	,@store INT
	,@GroupId INT
AS
BEGIN
	IF (@CostCenterId = 0)
	BEGIN
		INSERT INTO dbo.CostCenterInfo (
			CostCenterName
			,CostCenterAddedDate
			,CostCenterAddedBy
			,DefaultPrinter
			,coDiscount
			,NumberOfCounter
			,StoreId
			,GroupId
			)
		VALUES (
			@CostCenterName
			,-- CostCenterName - nvarchar(50)
			GETDATE()
			,-- CostCenterAddedDate - datetime
			@Username
			,-- CostCenterAddedBy - nvarchar(50)
			@DefaultPrinter
			,@coDiscount
			,@NumberOfCounter
			,@store
			,@GroupId
			)
	END
	ELSE
	BEGIN
		UPDATE CostCenterInfo
		SET CostCenterName = @CostCenterName
			,CostCenterAddedDate = GETDATE()
			,CostCenterAddedBy = @Username
			,DefaultPrinter = @DefaultPrinter
			,coDiscount = @coDiscount
			,NumberOfCounter = @NumberOfCounter
			,StoreId = @store
			,GroupId = @GroupId
		WHERE CostCenterInfo.CostCenterId = @CostCenterId
	END
END


GO
