SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_ROIITEMUPDATE]
@ITId int,
@ITName varchar(250),
@PITId INT,
--@ItemDetailsID int,
@ITCode varchar(250),
@CostCenterID int,
@ImagePath varchar(250),
@MUnitId int =null,
@DSUnitId int =null,
@DPUnitId int =null,
@IsExpirable bit =null,
@IsProdMaterial bit,
@IsUnitWiseRate bit =null,
@PRate decimal(18,0)=null,
@SRate decimal(18,0) =null,
@UnitID int =null,
--@ValidFrom datetime =null,
@PostedBy nvarchar(256),
@ROrderLevel int
--,@IsCategory bit
,@isMenu bit
,@IsActive bit
AS
BEGIN
	
	
	UPDATE ROI_ITEMMain SET 
	ITName=@ITName, 
	PITId=@PITId 
	,IsMenu=@isMenu
	,IsActive=@IsActive
	where ITId=@ITId
	--if(@IsCategory=0)
	--begin
	--update ROI_ItemDetails SET 
	--			ITCode=@ITCode,
	--			CostCenterID=@CostCenterID, 
	--			ImagePath=@ImagePath,
	--			MUnitId=@MUnitId, 
	--			DSUnitId=@DSUnitId, 
	--			DPUnitId=@DPUnitId,
	--			IsExpirable=@IsExpirable, 
	--			IsProdMaterial=@IsProdMaterial, 
	--			--ROrderLevel='2',
	--			ROrderLevel=@ROrderLevel,
	--			IsUnitWiseRate=@IsUnitWiseRate 
	--			WHERE ITId=@ITId

	--	update ROI_ItemRate  set
	--		PRate=@PRate,
	--		SRate=@SRate,
	--		UnitID=@UnitID,
	--		--ValidFrom=@ValidFrom,
	--		PostedBy=@PostedBy
	--			where @ITId=ItemID
	--	end
	--	else
		begin
		update ROI_ItemDetails SET 
				ITCode=@ITCode,
				ItemCostCentreID=@CostCenterID, 
				ImagePath=@ImagePath,
				--MUnitId=@MUnitId, 
				--DSUnitId=@DSUnitId, 
				--DPUnitId=@DPUnitId,
				--IsExpirable=@IsExpirable, 
				IsProdMaterial=@IsProdMaterial, 
				--ROrderLevel='2',
				ROrderLevel=@ROrderLevel
				--,IsUnitWiseRate=@IsUnitWiseRate 
				WHERE ITId=@ITId
		end
END




GO
