

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
 CONSTRAINT [PK_ROI_PurchaseDetails] PRIMARY KEY CLUSTERED 
(
	[PurchaseDetailsID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[ROI_PurchaseDetails]  WITH CHECK ADD  CONSTRAINT [FK_ROI_PurchaseDetails_ROI_PurchaseDetails] FOREIGN KEY([PurchaseDetailsID])
REFERENCES [dbo].[ROI_PurchaseDetails] ([PurchaseDetailsID])
GO

ALTER TABLE [dbo].[ROI_PurchaseDetails] CHECK CONSTRAINT [FK_ROI_PurchaseDetails_ROI_PurchaseDetails]
GO


