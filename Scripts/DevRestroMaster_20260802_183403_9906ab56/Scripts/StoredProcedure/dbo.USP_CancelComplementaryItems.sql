SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE[dbo].[USP_CancelComplementaryItems] @CompMasterID INT
	,@CompId INT
	,@Quantity INT
	,@RO_ItemID INT
	,@IsCombo BIT
	,@IsRunningOrder BIT
AS
BEGIN
	IF (@CompId = 0)
	BEGIN
		DECLARE @comp INT
			,@qnty INT
		DECLARE @continue BIT = 0

		WHILE (@continue = 0)
		BEGIN
			SELECT TOP (1) @comp = CompId
				,@qnty = Quantity
			FROM RO_ComplementaryItems od
			INNER JOIN RO_OrderItemStatus ois ON ois.OrderDetailID = od.CompId
			WHERE ois.StatusID = 1
				AND od.ROI_ItemId = @RO_ItemID
				AND od.IsCombo = @IsCombo
				AND od.IsCancelled = 0
			ORDER BY CompId DESC

			IF (@qnty <= @Quantity)
			BEGIN
				UPDATE RO_ComplementaryItems
				SET IsCancelled = 1
				WHERE CompId = @CompId

				SET @Quantity = (@Quantity - @qnty)

				IF (@Quantity > 0)
					SET @continue = 0
				ELSE
					SET @continue = 1
			END
			ELSE
			BEGIN
				UPDATE RO_ComplementaryItems
				SET Quantity = (Quantity - @Quantity)
				WHERE CompId = @CompId

				SET @continue = 1
			END
		END
	END
	ELSE
	BEGIN
		UPDATE RO_ComplementaryItems
		SET IsCancelled = 1
		WHERE CompId= @CompId
	END

	if ((select count(*) from RO_ComplementaryItems where CompMasterID=@CompMasterID and IsCancelled=0) = 0)
	begin
		update tblComplementaryMaster set IsCancelled=1 where CompMasterID=@CompMasterID
		UPDATE dbo.RO_restroTable
		SET restrotablesStatusID = 6
		WHERE restrotableId = (select TableId from tblComplementaryMaster where CompMasterID=@CompMasterID)

		UPDATE RO_MergeTable
		SET MergeTableList = 0
		WHERE MergeTableList = (select TableId from tblComplementaryMaster where CompMasterID=@CompMasterID)
	end
END




GO
