SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_UsersUpdateChanges]
 @Usernames NVARCHAR(4000),
 @IsActives NVARCHAR(4000),
 @PortalID INT,
 @UpdatedBy NVARCHAR(256)
WITH EXECUTE AS CALLER
AS
BEGIN
 DECLARE @tblUsername AS TABLE (
        RowNo int identity(1,1), 
        UserName nvarchar(256)
        )
        
 DECLARE @tblIsActive AS TABLE(
        RowNo int identity(1,1), 
        IsActive bit
       )
 DECLARE @Counter INT
 DECLARE @Count INT
 
 INSERT INTO @tblUsername(UserName)
 SELECT rtrim(ltrim(items)) FROM split(@Usernames,',')
 
 INSERT INTO @tblIsActive(IsActive)
   SELECT rtrim(ltrim(items)) FROM split(@IsActives,',')
 
 SELECT @Count=count(RowNo) FROM @tblUsername
 SET @Counter=1
 WHILE(@Counter<=@Count or @Counter=1)
 BEGIN  
  UPDATE dbo.Users SET 
       IsActive=(SELECT IsActive FROM @tblIsActive where RowNo=@Counter)
       ,UpdatedOn=getdate()
       ,UpdatedBy=@UpdatedBy
  WHERE PortalID=@PortalID AND [Username] = (SELECT UserName FROM @tblUsername where RowNo=@Counter )

  UPDATE dbo.PortalUser SET 
       IsActive=(SELECT IsActive FROM @tblIsActive where RowNo=@Counter)
       ,UpdatedOn=getdate()
       ,UpdatedBy=@UpdatedBy
  WHERE PortalID=@PortalID AND [Username] = (SELECT UserName FROM @tblUsername where RowNo=@Counter )

  UPDATE [dbo].[aspnet_Membership] SET IsApproved=(SELECT IsActive FROM @tblIsActive where RowNo=@Counter) 
  WHERE UserId=(SELECT UserId FROM [dbo].[PortalUser] WHERE ([Username] = (SELECT UserName FROM @tblUsername where RowNo=@Counter) AND PortalID=@PortalID))
  SET @Counter=@Counter+1
 END
END





GO
