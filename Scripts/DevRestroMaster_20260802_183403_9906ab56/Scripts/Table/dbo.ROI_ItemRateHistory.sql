SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ROI_ItemRateHistory](
	[HistoryItem] [int] IDENTITY(1,1) NOT NULL,
	[ItemID] [int] NULL,
	[IsCombo] [bit] NULL,
	[AddedBy] [nvarchar](256) NULL,
	[AddedOn] [datetime] NULL,
	[Operation] [int] NULL,
	[Rate] [decimal](18, 2) NULL,
 CONSTRAINT [PK_ROI_ItemRateHistory] PRIMARY KEY CLUSTERED 
(
	[HistoryItem] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
ALTER TABLE [dbo].[ROI_ItemRateHistory] ADD  CONSTRAINT [DF_ROI_ItemRateHistory_IsCombo]  DEFAULT ((0)) FOR [IsCombo]
GO
ALTER TABLE [dbo].[ROI_ItemRateHistory] ADD  CONSTRAINT [DF_ROI_ItemRateHistory_AddedOn]  DEFAULT (getdate()) FOR [AddedOn]
GO
