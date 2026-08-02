SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--getUnitsWithConvertion 26
CREATE PROCEDURE [dbo].[getUnitsWithConvertion] @itemId INT
AS
--declare @smallUnit int=1
SELECT u.Unit1Id UnitID
	,1 AS Conversion
	,u.Symbol Symbol
	,u.UnitDescription UnitDescription
	,1 AS IsFirst
	,(
		SELECT IsExpirable
		FROM ROI_ItemDetails
		WHERE ITId = @itemId
		) AS IsExpirable
		,@itemId ItemID
FROM ROI_Unit1 u
WHERE IsArchived = 0
	AND Unit1Id = (
		SELECT SmallUnit
		FROM ROI_ItemDetails
		WHERE ITId = @itemId
		)

UNION

SELECT u.FirstUnit UnitID
	,u.Conversion
	,u1.Symbol Symbol
	,u1.UnitDescription UnitDescription
	,0 AS IsFirst
	,(
		SELECT IsExpirable
		FROM ROI_ItemDetails
		WHERE ITId = @itemId
		) AS IsExpirable
		,@itemId ItemID
FROM ROI_Unit2 u
INNER JOIN ROI_Unit1 u1 ON u.FirstUnit = u1.Unit1Id
INNER JOIN ROI_Unit1 u2 ON u.SecondUnit = u2.Unit1Id
WHERE u.IsArchived = 0
	AND u2.IsArchived = 0
	AND SecondUnit = (
		SELECT SmallUnit
		FROM ROI_ItemDetails
		WHERE ITId = @itemId
		)
	--delete ROI_Unit2 where Unit2ID=35





GO
