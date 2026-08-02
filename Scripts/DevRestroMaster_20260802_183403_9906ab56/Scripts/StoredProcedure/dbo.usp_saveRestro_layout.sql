SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_saveRestro_layout] 
@TableID int , @RoomID int 
,@UserModuleID int
As begin 
if exists(select TableID from Restro_Layout where UserModuleID =  @UserModuleID and TableID=@TableID )
BEGIN
DELETE from  Restro_Layout where UserModuleID = @UserModuleID
END

Insert into Restro_Layout (TableID,RoomID,UserModuleID)
Values (@TableID,@RoomID,@UserModuleID)
END


GO
