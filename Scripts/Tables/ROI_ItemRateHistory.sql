

CREATE TABLE [dbo].[ROI_ItemRateHistory](
	[HistoryItem] [int] IDENTITY(1,1) NOT NULL,
	[ItemID] [int] NULL,
	[IsCombo] [bit] NULL CONSTRAINT [DF_ROI_ItemRateHistory_IsCombo]  DEFAULT ((0)),
	[AddedBy] [nvarchar](256) NULL,
	[AddedOn] [datetime] NULL CONSTRAINT [DF_ROI_ItemRateHistory_AddedOn]  DEFAULT (getdate()),
	[Operation] [int] NULL,
	[Rate] [decimal](16, 2) NULL,
 CONSTRAINT [PK_ROI_ItemRateHistory] PRIMARY KEY CLUSTERED 
(
	[HistoryItem] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'1= insert 2 = Update 3 = delete' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ROI_ItemRateHistory', @level2type=N'COLUMN',@level2name=N'Operation'
GO


