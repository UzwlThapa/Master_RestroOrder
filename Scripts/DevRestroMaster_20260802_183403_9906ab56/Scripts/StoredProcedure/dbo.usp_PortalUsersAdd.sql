SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_PortalUsersAdd]
 @UserID UNIQUEIDENTIFIER,
 @UserName NVARCHAR(256),
 @FirstName NVARCHAR(100),
 @LastName NVARCHAR(100),
 @Email NVARCHAR(256),
 @IsActive BIT,
 @AddedOn DATETIME,
 @PortalID INT,
 @AddedBy NVARCHAR(256)
AS
declare @PIN varchar(4)
 set @PIN = Right(SUBSTRING (RTRIM(RAND()) + SUBSTRING(RTRIM(RAND()),3,11), 3,11),4) 

 while(@PIN in (select PINcode from PortalUser))
 begin
 
 set @PIN = Right(SUBSTRING (RTRIM(RAND()) + SUBSTRING(RTRIM(RAND()),3,11), 3,11),4) 
 end
INSERT INTO [dbo].[PortalUser] (
 [UserID],
 [Username],
 [FirstName],
 [LastName],
 [Email],
 [IsActive],
 [AddedOn],
 [PortalID],
 [IsDeleted],
 [AddedBy],
 [PINcode]
) VALUES (
 @UserID,
 @UserName,
 @FirstName,
 @LastName,
 @Email,
 @IsActive,
 GETDATE(),
 @PortalID,
 0,
 @AddedBy,
  @PIN
)




GO
