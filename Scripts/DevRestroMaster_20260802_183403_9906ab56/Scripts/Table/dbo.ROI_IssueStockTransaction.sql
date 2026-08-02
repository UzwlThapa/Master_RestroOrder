SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ROI_IssueStockTransaction](
	[IssueTranId] [int] IDENTITY(1,1) NOT NULL,
	[IssueDetailId] [int] NULL,
	[FromStoreId] [int] NULL,
	[ToStoreId] [int] NULL,
	[ItemId] [int] NULL,
	[IssueQty] [decimal](18, 2) NULL,
	[IssueUnit] [int] NULL,
	[IssueAmt] [decimal](18, 2) NULL,
	[TransactionDate] [datetime] NULL,
 CONSTRAINT [PK__ROI_Issu__2DF4CF5E3AB32533] PRIMARY KEY CLUSTERED 
(
	[IssueTranId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
