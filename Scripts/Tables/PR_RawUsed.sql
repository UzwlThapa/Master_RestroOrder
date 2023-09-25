

CREATE TABLE [dbo].[PR_RawUsed](
	[RawUsedID] [int] IDENTITY(1,1) NOT NULL,
	[ProductionInstantID] [int] NULL,
	[ItemID] [int] NULL,
	[StoreID] [int] NULL,
	[UnitID] [int] NULL,
	[Quantity] [decimal](16, 4) NULL,
 CONSTRAINT [PK_PR_RawUsed] PRIMARY KEY CLUSTERED 
(
	[RawUsedID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO


