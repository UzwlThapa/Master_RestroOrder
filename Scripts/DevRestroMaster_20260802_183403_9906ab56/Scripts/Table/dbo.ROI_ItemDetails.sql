SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ROI_ItemDetails](
	[ItemDetailsID] [int] IDENTITY(1,1) NOT NULL,
	[ITId] [int] NULL,
	[ITCode] [varchar](250) NULL,
	[CostCenterID] [int] NULL,
	[ImagePath] [varchar](250) NULL,
	[MUnitId] [int] NULL,
	[DSUnitId] [int] NULL,
	[DPUnitId] [int] NULL,
	[IsExpirable] [bit] NULL,
	[IsProdMaterial] [bit] NULL,
	[ROrderLevel] [int] NULL,
	[IsUnitWiseRate] [bit] NULL,
	[ItemCostCentreID] [int] NULL,
	[Details] [varchar](max) NULL,
	[IsExtra] [bit] NULL,
	[AddedBy] [nvarchar](256) NULL,
	[AddedOn] [datetime] NULL,
	[UpdatedOn] [datetime] NULL,
	[UpdatedBy] [nvarchar](256) NULL,
	[IsUpdated] [bit] NULL,
	[IsArchived] [bit] NULL,
	[ArchivedBy] [nvarchar](256) NULL,
	[ArchivedOn] [datetime] NULL,
	[IsMenu] [bit] NULL,
	[SmallUnit] [int] NULL,
	[IsOutOfStock] [bit] NULL,
 CONSTRAINT [PK_tbl_ITEMDetls] PRIMARY KEY CLUSTERED 
(
	[ItemDetailsID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
CREATE NONCLUSTERED INDEX [IX_ItemDetails_ITId] ON [dbo].[ROI_ItemDetails]
(
	[ITId] ASC
)
INCLUDE([SmallUnit],[ItemCostCentreID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_ROI_ItemDetails_ITId] ON [dbo].[ROI_ItemDetails]
(
	[ITId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
