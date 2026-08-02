SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_ROI_ITEMRATESAVE]
@ItemRateID INT,
@ItemID INT,
@UnitID INT,
@PRate decimal(18, 0),
@SRate decimal(18, 2),
--@ValidFrom DATETIME,
@PostedBy nvarchar(256)
--@PostedOn datetime
AS
BEGIN
	IF(@ItemRateID = 0)
	BEGIN
		INSERT INTO DBO.ROI_ITEMRATE (ItemID, UnitID, PRate, SRate, 
		--ValidFrom, 
		PostedBy, PostedOn)
		VALUES (@ItemID, @UnitID, @PRate, @SRate,
		-- @ValidFrom,
		 @PostedBy, getdate())
	END
	ELSE
    BEGIN
		 UPDATE ROI_ITEMRATE SET 
		 ItemID= @ItemID,
		 UnitID= @UnitID,
		 PRate = @PRate,
		 SRate = @SRate,
		 --ValidFrom = @ValidFrom,
		 PostedBy = @PostedBy,
		 PostedOn = getdate() WHERE 	ItemRateID = @ItemRateID 
	END
END



GO
