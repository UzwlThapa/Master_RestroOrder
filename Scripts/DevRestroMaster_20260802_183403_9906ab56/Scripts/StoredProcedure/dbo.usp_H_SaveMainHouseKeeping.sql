SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

	--select * from H_HouseKeeping
	--[usp_H_SaveMainHouseKeeping] '0','1','SR1','super-Room','dirty','No','2016-12-45 56 78','Superuser'
	--'usp_H_SaveMainHouseKeeping' 
	CREATE PROCEDURE [dbo].[usp_H_SaveMainHouseKeeping]
	-- Add the parameters for the stored procedure here

	@HK_ID	int,
	@RoomID	int,
	@RoomType	nvarchar(250),
	@Room varchar(128),
	@RoomStatus nvarchar(50),
	@Availability nvarchar(50),
	@HK_Date varchar(128),
	--@Time_Min varchar(128),
	@Remarks_HK nvarchar(500),
	@AssignTo nvarchar(150)
	--@AddedOn	datetime

	AS
	BEGIN
	--IF	(@HK_ID = 0)
	update H_HouseKeeping set IsActive=0 where RoomID=@RoomID and IsActive=1

	INSERT INTO H_HouseKeeping(
	RoomID,
	RoomType,
	Room,
	RoomStatus,
	Availability,
	HK_Date,
	Remarks_HK,
	AssignTo
	)
	VALUES
	(
		@RoomID, 
	@RoomType,
	@Room,
	@RoomStatus,
	@Availability,
	@HK_Date,
	@Remarks_HK,
	@AssignTo
	)
	--ELSE
	--UPDATE H_HouseKeeping
	--	SET			
	--		RoomID = @RoomID,
	--		RoomType = @RoomType,
	--		Room = @Room,
	--		RoomStatus = @RoomStatus,
	--		Availability = @Availability,
	--		--CustomerID = 120,
	--		Remarks_HK = @Remarks_HK,
	--		AssignTo = @AssignTo
	--	WHERE HK_ID= @HK_ID
	END



GO
