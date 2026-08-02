SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_RO_ROOMTYPESAVE]
@RoomTypeID INT,
@Title varchar(200),
@Description varchar(MAX),
@InsertedBy varchar(50),
@UpdateBy VARCHAR(50)
AS
BEGIN
IF(@RoomTypeID=0)
BEGIN
INSERT INTO dbo.Ro_RoomType
        ( Title ,
          Description ,
          InsertedBy 
        )
VALUES  ( 
			@Title,
			@Description,
			@InsertedBy
        )

END
ELSE
BEGIN
UPDATE dbo.Ro_RoomType SET Title=@Title, Description=@Description,UpdateBy=@UpdateBy WHERE RoomTypeID = @RoomTypeID
end
	
END




GO
