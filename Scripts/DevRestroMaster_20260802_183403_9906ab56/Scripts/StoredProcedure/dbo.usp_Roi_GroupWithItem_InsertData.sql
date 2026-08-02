SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_Roi_GroupWithItem_InsertData] @GroupID INT
	,@ItemID INT
	,@userName NVARCHAR(256)
AS
IF EXISTS (
		SELECT *
		FROM Roi_GroupWithItem gwi
		WHERE gwi.GroupID = @GroupID
		)
BEGIN
	--delete Roi_GroupWithItem where GroupID=@GroupID
	IF EXISTS (
			SELECT *
			FROM Roi_GroupWithItem gwi
			WHERE gwi.GroupID = @GroupID
				AND ItemID = @ItemID
			)
	BEGIN
		UPDATE Roi_GroupWithItem
		SET UpdatedBy = @userName
			,UpdatedOn = getdate()
		WHERE ItemID = @ItemID
			AND GroupID = @GroupID
	END
	ELSE
	BEGIN
		INSERT INTO Roi_GroupWithItem (
			GroupID
			,ItemID
			,IsArchived
			,AddedBy
			,AddedOn
			)
		VALUES (
			@GroupID
			,@ItemID
			,0
			,@userName
			,getdate()
			)
	END
END
ELSE
BEGIN
	INSERT INTO Roi_GroupWithItem (
		GroupID
		,ItemID
		,IsArchived
		,AddedBy
		,AddedOn
		)
	VALUES (
		@GroupID
		,@ItemID
		,0
		,@userName
		,getdate()
		)
END
		--select * from Roi_GroupWithItem




GO
