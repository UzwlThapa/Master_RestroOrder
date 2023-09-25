

CREATE TABLE [dbo].[RO_Items](
	[ItemID] [int] IDENTITY(1,1) NOT NULL,
	[ItemName] [nvarchar](128) NULL,
	[ItemDescription] [nvarchar](128) NULL,
	[PhotoPath] [varchar](128) NULL,
	[Price] [decimal](18, 2) NULL,
	[ItemCode] [varchar](128) NULL,
	[UnitID] [int] NOT NULL,
	[CategoryID] [int] NOT NULL,
	[CostCenterID] [int] NULL,
 CONSTRAINT [PK_RO_Items] PRIMARY KEY CLUSTERED 
(
	[ItemID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


