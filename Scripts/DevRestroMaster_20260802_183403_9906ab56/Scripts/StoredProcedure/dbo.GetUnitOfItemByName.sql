SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--GetUnitOfItemByName 'wheat flour'
CREATE PROCEDURE [dbo].[GetUnitOfItemByName] @itemId NVARCHAR(256)
AS
--declare @smallUnit int=1
declare @ID int=(SELECT ITId
				FROM ROI_ITEMMain
				WHERE ITName = @itemId)
SELECT u.Unit1Id UnitID
	,1 AS Conversion
	,u.Symbol Symbol
	,u.UnitDescription UnitDescription
	,1 AS IsFirst
	,(
		SELECT IsExpirable
		FROM ROI_ItemDetails
		WHERE ITId = (
				SELECT ITId
				FROM ROI_ITEMMain
				WHERE ITName = @itemId
				)
		) AS IsExpirable
		,@ID ItemID
FROM ROI_Unit1 u
WHERE IsArchived = 0
	AND Unit1Id = (
		SELECT SmallUnit
		FROM ROI_ItemDetails
		WHERE ITId = (
				SELECT ITId
				FROM ROI_ITEMMain
				WHERE ITName = @itemId
				)
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
		WHERE ITId = (
				SELECT ITId
				FROM ROI_ITEMMain
				WHERE ITName = @itemId
				)
		) AS IsExpirable
		,@ID ItemID
FROM ROI_Unit2 u
INNER JOIN ROI_Unit1 u1 ON u.FirstUnit = u1.Unit1Id
INNER JOIN ROI_Unit1 u2 ON u.SecondUnit = u2.Unit1Id
WHERE u2.IsArchived = 0
	AND SecondUnit = (
		SELECT SmallUnit
		FROM ROI_ItemDetails
		WHERE ITId = (
				SELECT ITId
				FROM ROI_ITEMMain
				WHERE ITName = @itemId
				)
		)
	--delete ROI_Unit2 where Unit2ID=35



GO
