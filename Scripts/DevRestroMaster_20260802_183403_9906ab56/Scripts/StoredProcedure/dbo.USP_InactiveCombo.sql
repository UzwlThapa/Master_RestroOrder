SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_InactiveCombo]
AS
BEGIN
	--UPDATE RO_Combo
	--SET IsActive = 0
	--WHERE cast(EndDate AS DATE) < cast(getdate() AS DATE)
	UPDATE RO_Combo
	SET IsActive = 0
	WHERE 
   DATEADD(DAY,1,DATEADD(HOUR,5,EndDate)) < getdate() 
END

GO
