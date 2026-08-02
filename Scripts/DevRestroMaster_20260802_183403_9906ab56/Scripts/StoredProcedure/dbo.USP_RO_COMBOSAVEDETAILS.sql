SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_RO_COMBOSAVEDETAILS]
@ComboID INT,
@ItemID INT,
@ItemRate decimal(14, 4),
@Quantity FLOAT,
@TotalPrice	decimal(14, 4)

AS
BEGIN
	insert into RO_ComboDetails (
	ComboID,
	ItemID,
	ItemRate,
	Quantity,
	TotalPrice) values(
	@ComboID,
	@ItemID,
	@ItemRate,
	@Quantity,
	@TotalPrice)
	
END



GO
