SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

	--select * from H_LostAndFound
	--[usp_H_SaveLostAndFound] '16','1','5','No','Good washing','Superuser','Do'
	CREATE PROCEDURE [dbo].[usp_H_SaveLostAndFound]
	-- Add the parameters for the stored procedure here

	@LF_ID	int,
	@RoomType	nvarchar(250),
	@Room varchar(128),
	@Date varchar(128),
	@Guest_Name nvarchar(250),
	@Type nvarchar(50),
	@Item_Name nvarchar(500)

	AS
	BEGIN
	IF	(@LF_ID = 0)

	INSERT INTO H_LostAndFound(
	RoomType,
	Room,
	Date,
	Guest_Name,
	Type,
	Item_Name
	)
	VALUES
	(
	@RoomType,
	@Room,
	@Date,
	@Guest_Name,
	@Type,
	@Item_Name
	)
	ELSE
	UPDATE H_LostAndFound
		SET			
			RoomType = @RoomType,
			Room = @Room,
			Date = @Date,
			Guest_Name = @Guest_Name,
			Type = @Type,
			Item_Name = @Item_Name
		WHERE LF_ID= @LF_ID
	END



GO
