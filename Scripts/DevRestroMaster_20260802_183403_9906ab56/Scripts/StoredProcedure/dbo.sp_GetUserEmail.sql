SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:  
-- Create date: 2010-04-15
-- Description: <Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetUserEmail]
@UserName NVARCHAR(256),
@PortalID INT
AS
BEGIN
SELECT Email FROM
dbo.Users
WHERE PortalID=@PortalId AND Username=@UserName
END





GO
