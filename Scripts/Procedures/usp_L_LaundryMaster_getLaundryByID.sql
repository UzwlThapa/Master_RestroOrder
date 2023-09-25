CREATE PROCEDURE [dbo].[usp_L_LaundryMaster_getLaundryByID] @lmasterID INT
AS
SELECT L_LaundryDetails.ID
	,L_LaundryDetails.ClothID
	,L_LaundryDetails.MaterialID
	,L_LaundryDetails.LaundryTypeID
	,L_LaundryDetails.LaundryMasterID
	,L_Cloth.Cloth AS Cloth
	,L_LaundryDetails.Color
	,L_LaundryDetails.Description
	,L_MaterialType.Type AS Material
	,L_LaundryType.Type AS LaundryType
	,L_LaundryDetails.Quantity
	,L_LaundryDetails.Rate
	,L_LaundryDetails.IsDelivered
FROM dbo.L_LaundryDetails
LEFT JOIN L_Cloth ON L_Cloth.ID = L_LaundryDetails.ClothID
LEFT JOIN L_MaterialType ON L_MaterialType.ID = L_LaundryDetails.MaterialID
LEFT JOIN L_LaundryType ON L_LaundryType.ID = L_LaundryDetails.LaundryTypeID
WHERE dbo.L_LaundryDetails.LaundryMasterID = @lmasterID
