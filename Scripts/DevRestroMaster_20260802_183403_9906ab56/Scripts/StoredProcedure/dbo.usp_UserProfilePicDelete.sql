SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_UserProfilePicDelete]
(
@UserName NVARCHAR(250),
@PortalID INT
)
AS
BEGIN
UPDATE [dbo].[UserDetails]
SET [image]=''
WHERE UserName=@UserName and PortalID=@PortalID   
END





GO
