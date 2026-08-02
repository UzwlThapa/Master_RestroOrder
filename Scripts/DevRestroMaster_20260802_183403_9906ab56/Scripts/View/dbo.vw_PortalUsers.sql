SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_PortalUsers]
AS
SELECT        dbo.aspnet_Users.UserId, dbo.aspnet_Users.UserName, dbo.aspnet_Users.LoweredUserName, dbo.aspnet_Users.LastActivityDate, dbo.aspnet_Membership.Email, dbo.aspnet_Membership.LastLoginDate, 
                         dbo.aspnet_Membership.LastPasswordChangedDate, dbo.aspnet_Membership.LastLockoutDate, dbo.PortalUser.PortalID, dbo.Portal.SEOName AS PortalSEOName, dbo.PortalUser.LastName, 
                         dbo.PortalUser.FirstName, dbo.PortalUser.IsActive, dbo.PortalUser.IsModified, dbo.PortalUser.AddedOn, dbo.PortalUser.UpdatedOn, dbo.PortalUser.DeletedOn, dbo.PortalUser.AddedBy, 
                         dbo.PortalUser.UpdatedBy, dbo.PortalUser.DeletedBy, dbo.PortalUser.IsDeleted, dbo.PortalUser.PINcode
FROM            dbo.aspnet_Users INNER JOIN
                         dbo.aspnet_Membership ON dbo.aspnet_Membership.UserId = dbo.aspnet_Users.UserId INNER JOIN
                         dbo.PortalUser ON dbo.aspnet_Users.UserId = dbo.PortalUser.UserID INNER JOIN
                         dbo.Portal ON dbo.PortalUser.PortalID = dbo.Portal.PortalID
WHERE        (dbo.PortalUser.IsDeleted = 0) OR
                         (dbo.PortalUser.IsDeleted IS NULL) AND (dbo.PortalUser.IsActive = 1)




GO
