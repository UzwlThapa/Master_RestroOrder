SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RO_PurchaseReturnDetails](
	[PRDetailsID] [int] IDENTITY(1,1) NOT NULL,
	[PurchaseReturnId] [int] NULL,
	[GDId] [int] NULL,
	[STId] [int] NULL,
	[ItemID] [int] NULL,
	[Qnty] [decimal](18, 2) NULL,
	[UsedUnitID] [int] NULL,
	[Rate] [decimal](10, 2) NULL,
	[Total] [decimal](10, 2) NULL,
 CONSTRAINT [PK_RO_PurchaseReturnDetails] PRIMARY KEY CLUSTERED 
(
	[PRDetailsID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
