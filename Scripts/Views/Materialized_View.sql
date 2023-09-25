

CREATE VIEW [dbo].[Materialized_View]
AS
SELECT        SM.FiscalYearID AS FiscalYear, 'RO' + fy.fyName + '-' + CAST(SM.InvoiceNo - fy.FirstSalesMasterID AS varchar(20)) AS Bill_No, SM.CusName AS Customer_Name, '' AS Customer_PAN, SM.BillDate AS Bill_Date, 
                         SM.BasicAmount + SM.totaldiscount AS AMOUNT, SM.totaldiscount AS Discount, bA1.Amount AS ServiceCharge, SM.BasicAmount + bA1.Amount AS TaxableAmount, bA2.Amount AS Tax_Amount, 
                         CASE WHEN PD.PrintedBy IS NULL THEN 0 ELSE 1 END AS Is_Printed, ~ SM.IsArchived AS Is_Active, MIN(PD.PrintedDate) AS Printed_Time, MIN(SM.AddedBy) AS Entered_by, MIN(PD.PrintedBy) 
                         AS Printed_by
FROM            dbo.RO_SalesMaster AS SM INNER JOIN
                         dbo.RO_fiscalYear AS fy ON SM.FiscalYearID = fy.fyId LEFT OUTER JOIN
                         dbo.PrintDetail AS PD ON SM.salesMasterId = PD.PrintBillNo LEFT OUTER JOIN
                         dbo.RO_BillingAmount AS bA1 ON bA1.SalesMasterID = SM.salesMasterId AND bA1.IsVoid = 0 AND bA1.BilingID = 62 LEFT OUTER JOIN
                         dbo.RO_BillingAmount AS bA2 ON bA2.SalesMasterID = SM.salesMasterId AND bA2.IsVoid = 0 AND bA2.BilingID = 54
GROUP BY SM.salesMasterId, SM.FiscalYearID, fy.fyName, fy.FirstSalesMasterID, SM.CusName, SM.BillDate, SM.BasicAmount, SM.totaldiscount, bA1.Amount, bA2.Amount, PD.PrintedBy, SM.IsArchived, SM.InvoiceNo


GO

EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[41] 4[20] 2[33] 3) )"
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
         Begin Table = "SM"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 208
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "fy"
            Begin Extent = 
               Top = 6
               Left = 246
               Bottom = 136
               Right = 446
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "PD"
            Begin Extent = 
               Top = 6
               Left = 454
               Bottom = 136
               Right = 625
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "bA1"
            Begin Extent = 
               Top = 138
               Left = 38
               Bottom = 268
               Right = 224
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "bA2"
            Begin Extent = 
               Top = 138
               Left = 262
               Bottom = 268
               Right = 448
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
      Begin ColumnWidths = 12
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
End' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Materialized_View'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Materialized_View'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Materialized_View'
GO


