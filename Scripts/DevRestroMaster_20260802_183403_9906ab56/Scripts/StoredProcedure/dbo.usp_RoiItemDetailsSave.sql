SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_RoiItemDetailsSave] @ItemDetailsID INT
	,@ITId INT
	,@ITCode VARCHAR(250)
	,@CostCenterID INT =null
	,@ImagePath VARCHAR(250)
	,@MUnitId INT =null
	,@DSUnitId INT =null
	,@DPUnitId INT =null
	,@IsExpirable BIT =null
	,@IsProdMaterial BIT
	,@ROrderLevel INT
	,@IsUnitWiseRate BIT =null
	,@ItemCostCentreID INT
	,@Details VARCHAR(max) =null
	--,@isMenu BIT
	--,@IsCategory BIT
AS
--BEGIN
--	IF (@IsCategory = 0)
--	BEGIN
--		IF (@ItemDetailsID = 0)
--		BEGIN
--			INSERT INTO ROI_ItemDetails (
--				ITId
--				,ITCode
--				,CostCenterID
--				,ImagePath
--				,MUnitId
--				,DSUnitId
--				,DPUnitId
--				,IsExpirable
--				,IsProdMaterial
--				,ROrderLevel
--				,IsUnitWiseRate
--				,ItemCostCentreID
--				,Details
--				,isMenu,
--				IsArchived
--				)
--			VALUES (
--				@ITId
--				,@ITCode
--				,@CostCenterID
--				,@ImagePath
--				,@MUnitId
--				,@DSUnitId
--				,@DPUnitId
--				,@IsExpirable
--				,@IsProdMaterial
--				,@ROrderLevel
--				,@IsUnitWiseRate
--				,@ItemCostCentreID
--				,@Details
--				,@isMenu,
--				0
--				)
--		END
--	END
--	ELSE
	BEGIN
		INSERT INTO ROI_ItemDetails (
			ITId
			,ITCode
			,ItemCostCentreID
			,ImagePath
			,IsProdMaterial
			,ROrderLevel
			--,isMenu,
			,IsArchived
			)
		VALUES (
			@ITId
			,@ITCode
			,@ItemCostCentreID
			,@ImagePath
			,@IsProdMaterial
			,@ROrderLevel
			--,@isMenu
			,0
			)
	END
--END





GO
