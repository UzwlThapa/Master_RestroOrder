

CREATE TABLE [dbo].[ROI_ItemRate](
	[ItemRateID] [int] IDENTITY(1,1) NOT NULL,
	[ItemID] [int] NOT NULL,
	[UnitID] [int] NULL,
	[PRate] [decimal](18, 0) NULL,
	[SRate] [decimal](18, 2) NULL,
	[ValidFrom] [datetime] NULL,
	[PostedBy] [nvarchar](256) NULL,
	[PostedOn] [datetime] NULL,
	[LargeUnit] [int] NULL,
	[Conversion] [int] NULL,
	[IsDefaultPurchaseUnit] [bit] NULL,
	[IsDefaultSalesUnit] [bit] NULL,
	[UpdatedOn] [datetime] NULL,
	[UpdatedBy] [nvarchar](256) NULL,
	[IsUpdated] [bit] NULL,
	[IsArchived] [bit] NULL,
	[ArchivedBy] [nvarchar](256) NULL,
	[ArchivedOn] [datetime] NULL,
 CONSTRAINT [PK_ITEMRate] PRIMARY KEY CLUSTERED 
(
	[ItemRateID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO


