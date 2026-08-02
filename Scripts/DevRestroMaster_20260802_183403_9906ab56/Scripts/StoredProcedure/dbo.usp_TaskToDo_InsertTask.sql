SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_TaskToDo_InsertTask] 
 -- Add the parameters for the stored procedure here
 @Note ntext,
 @date datetime,
 @PortalID int,
 @ModuleId int,
 @CultureField nvarchar(200),
 @UserName nvarchar(200),
 @Id int
AS
BEGIN

 SET NOCOUNT ON;
 IF(@Id=0)
 BEGIN
 
 INSERT INTO TaskToDo(Note,Date, CultureField,portalID,ModuleId,AddedBy,AddedOn,IsDeleted)
 VALUES(@Note,@date,@CultureField,@PortalID,@ModuleId,@UserName,GETDATE(),0)
 END
 ELSE
 BEGIN
 UPDATE TaskToDo SET Note=@Note,Date=@date,UpdateBy=@UserName,updateOn=GETDATE()
 WHERE TaskID=@Id
    END 
END





GO
