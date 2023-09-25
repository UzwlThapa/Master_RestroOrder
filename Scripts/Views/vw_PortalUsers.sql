

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

EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "aspnet_Users"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 227
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "aspnet_Membership"
            Begin Extent = 
               Top = 138
               Left = 38
               Bottom = 268
               Right = 359
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "PortalUser"
            Begin Extent = 
               Top = 6
               Left = 265
               Bottom = 136
               Right = 435
            End
            DisplayFlags = 280
            TopColumn = 13
         End
         Begin Table = "Portal"
            Begin Extent = 
               Top = 270
               Left = 38
               Bottom = 400
               Right = 208
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vw_PortalUsers'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vw_PortalUsers'
GO


