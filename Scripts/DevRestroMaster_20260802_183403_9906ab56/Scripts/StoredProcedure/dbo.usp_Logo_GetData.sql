SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:  <Author,,Name>
-- Create date: <Create Date,,>
-- Description: <Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[usp_Logo_GetData] 
 @UserModuleID INT,
 @PortalID INT,
 @CultureCode NVARCHAR(100)
AS
BEGIN
 SELECT LogoText,LogoPath,Slogan,url FROM dbo.[Logo] 
 WHERE UserModuleID=@UserModuleID AND PortalID=@PortalID AND CultureCode=@CultureCode
END





GO
