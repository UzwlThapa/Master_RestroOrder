 CREATE PROCEDURE [dbo].[usp_L_SaveLaundryDetails] @LaundryMasterID INT
	,@ClothID INT
	,@MaterialID INT
	,@Color NVARCHAR(max)
	,@Description NVARCHAR(max)
	,@LaundryTypeID INT
	,@Quantity INT
	,@Rate INT
	,@isdelivered bit
AS
INSERT INTO dbo.L_LaundryDetails (
	LaundryMasterID
	,ClothID
	,MaterialID
	,Color
	,[Description]
	,LaundryTypeID
	,Quantity
	,Rate
	,IsDelivered
	)
VALUES (
	@LaundryMasterID
	,@ClothID
	,@MaterialID
	,@Color
	,@Description
	,@LaundryTypeID
	,@Quantity
	,@Rate
	,@isdelivered
	)