

CREATE TABLE [dbo].[Roi_ItemWithUnit](
	[ItemWithUnitID] [int] IDENTITY(1,1) NOT NULL,
	[ItemID] [int] NOT NULL,
	[LargeUnit] [int] NULL,
	[Conversion] [int] NULL,
	[IsDefaultPurchaseUnit] [bit] NULL,
	[IsDefaultSalesUnit] [bit] NULL,
	[SalesRate] [decimal](18, 2) NULL,
	[ValidFrom] [datetime] NULL,
	[AddedBy] [nvarchar](256) NULL,
	[AddedOn] [datetime] NULL,
	[UpdatedOn] [datetime] NULL,
	[UpdatedBy] [nvarchar](256) NULL,
	[IsUpdated] [bit] NULL,
	[IsArchived] [bit] NULL,
	[ArchivedBy] [nvarchar](256) NULL,
	[ArchivedOn] [datetime] NULL,
 CONSTRAINT [PK_Roi_ItemWithUnit] PRIMARY KEY CLUSTERED 
(
	[ItemWithUnitID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO


