SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ROI_StockVariance](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[ItemId] [int] NULL,
	[STId] [int] NULL,
	[ItemBal] [decimal](18, 2) NULL,
	[ItemUnit] [int] NULL,
	[ActualBal] [decimal](18, 2) NULL,
	[AddedOn] [datetime] NULL,
	[AddedBy] [nvarchar](250) NULL,
 CONSTRAINT [PK_ROI_StockVariance] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
ALTER TABLE [dbo].[ROI_StockVariance] ADD  CONSTRAINT [DF_ROI_StockVariance_AddedOn]  DEFAULT (getdate()) FOR [AddedOn]
GO
