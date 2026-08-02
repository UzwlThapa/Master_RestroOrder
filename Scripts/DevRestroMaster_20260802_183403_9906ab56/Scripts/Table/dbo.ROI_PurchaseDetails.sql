SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ROI_PurchaseDetails](
	[PurchaseDetailsID] [int] IDENTITY(1,1) NOT NULL,
	[StoreID] [int] NULL,
	[PurchaseMainID] [int] NULL,
	[ItemID] [int] NULL,
	[UsedUnitID] [int] NULL,
	[Quentity] [decimal](18, 2) NULL,
	[QuentityText] [nvarchar](200) NULL,
	[UnitRate] [decimal](18, 2) NULL,
	[Total] [decimal](18, 2) NULL,
	[Conversion] [int] NULL,
	[RecqDetailId] [int] NULL,
	[VendorPurchaseId] [int] NULL,
	[Discount] [decimal](10, 2) NULL,
	[IsVat] [bit] NULL,
 CONSTRAINT [PK_ROI_PurchaseDetails] PRIMARY KEY CLUSTERED 
(
	[PurchaseDetailsID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
CREATE NONCLUSTERED INDEX [IX_PurchaseDetails_Item_Store] ON [dbo].[ROI_PurchaseDetails]
(
	[ItemID] ASC,
	[StoreID] ASC
)
INCLUDE([UnitRate]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ROI_PurchaseDetails]  WITH CHECK ADD  CONSTRAINT [FK_ROI_PurchaseDetails_ROI_PurchaseDetails] FOREIGN KEY([PurchaseDetailsID])
REFERENCES [dbo].[ROI_PurchaseDetails] ([PurchaseDetailsID])
GO
ALTER TABLE [dbo].[ROI_PurchaseDetails] CHECK CONSTRAINT [FK_ROI_PurchaseDetails_ROI_PurchaseDetails]
GO
