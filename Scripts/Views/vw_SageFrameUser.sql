


CREATE VIEW [dbo].[vw_SageFrameUser]
AS
SELECT     dbo.aspnet_Users.UserId, dbo.aspnet_Users.UserName, dbo.Users.FirstName, dbo.Users.LastName, dbo.aspnet_Users.LoweredUserName, 
                      dbo.aspnet_Users.LastActivityDate, dbo.aspnet_Membership.Email, dbo.aspnet_Membership.LastLoginDate, 
                      dbo.aspnet_Membership.LastPasswordChangedDate, dbo.aspnet_Membership.LastLockoutDate, dbo.PortalUser.PortalID, 
                      dbo.Portal.SEOName AS PortalSEOName, dbo.Users.IsActive, dbo.Users.IsModified, dbo.Users.AddedOn, dbo.Users.UpdatedOn, dbo.Users.DeletedOn,
                       dbo.Users.AddedBy, dbo.Users.UpdatedBy, dbo.Users.DeletedBy, dbo.Users.IsDeleted
FROM         dbo.Users INNER JOIN
                      dbo.aspnet_Users ON dbo.Users.Username = dbo.aspnet_Users.UserName INNER JOIN
                      dbo.aspnet_Membership ON dbo.aspnet_Membership.UserId = dbo.aspnet_Users.UserId INNER JOIN
                      dbo.PortalUser ON dbo.Users.Username = dbo.PortalUser.Username INNER JOIN
                      dbo.Portal ON dbo.PortalUser.PortalID = dbo.Portal.PortalID
WHERE     (dbo.Users.IsDeleted = 0) OR
                      (dbo.Users.IsDeleted IS NULL)



GO


