
CREATE PROCEDURE [dbo].[usp_L_getRatebyId] @cloth INT
	,@Ltype INT
AS
SELECT ISNULL((
			SELECT cast(lr.Rate AS DECIMAL) AS Rate
			FROM L_LaundryRate lr
			--join L_Cloth lc on lr.ClothTypeID=lc.ID join 
			-- L_MaterialType mt on mt.ID=lr.LaundryTypeID
			WHERE lr.ClothTypeID = @cloth
				AND lr.LaundryTypeID = @Ltype
			), 0) AS Rate
