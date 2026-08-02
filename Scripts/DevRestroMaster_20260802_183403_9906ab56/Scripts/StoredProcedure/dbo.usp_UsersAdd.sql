SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_UsersAdd] 
(@UserID INT OUTPUT,
 @UserName NVARCHAR (256),
 @FirstName NVARCHAR (100),
 @LastName NVARCHAR (100),
 @Email NVARCHAR (256),
 @IsActive BIT,
 @AddedOn DATETIME,
 @PortalID INT,
 @AddedBy NVARCHAR (256))
 AS
BEGIN
 INSERT INTO [dbo].Users (
 [Username],
 [FirstName],
 [LastName],
 [Email],
 [IsActive],
 [AddedOn],
 [PortalID],
 [AddedBy]
)
VALUES
 (
  @UserName,
  @FirstName,
  @LastName,
  @Email,
  @IsActive,
  @AddedOn,
  @PortalID,
  @AddedBy
 )
SET @UserID = SCOPE_IDENTITY()
END





GO
