SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_SaveStockVariance]
@ItemId int,
@STId int,
@ItemBal decimal(18,2),
@ItemUnit int,
@ActualBal decimal(18,2),
@AddedBy nvarchar(250),
@Conversion decimal (18,2) = 1

AS
	BEGIN
	
	INSERT INTO roi_stockvariance 
			(
			ItemId,
			STId,
			ItemBal,
			ItemUnit,
			ActualBal,
			AddedBy)
	Values (
			@ItemId,
			@STId,
			@ItemBal,
			@ItemUnit,
			@ActualBal,
			@AddedBy
	)

	update ROI_ITEMBal set CLBal = @ActualBal * @Conversion 
	where ITId=@ItemId and STId = @STId

	END

GO
