SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_GetUserActivationCode]
 @UserName NVARCHAR(256),
 @PortalID INT
AS
BEGIN
SELECT UserId FROM
dbo.aspnet_users
WHERE Username=@UserName
END
/****** Object:  StoredProcedure [dbo].[sp_GetUserEmail]    Script Date: 12/02/2012 13:13:10 ******/
SET ANSI_NULLS ON





GO
