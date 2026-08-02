SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RO_SalesDetailExtra](
	[ExtraId] [int] IDENTITY(1,1) NOT NULL,
	[SalesMasterId] [int] NULL,
	[SalesDetailsId] [int] NULL,
	[ItemId] [int] NULL,
	[ExtraItemId] [int] NULL,
	[ExtraItem] [nvarchar](256) NULL,
	[Quantity] [int] NULL,
	[Rate] [decimal](18, 2) NULL,
	[Amount] [decimal](18, 2) NULL,
	[HSCode] [nvarchar](10) NULL,
PRIMARY KEY CLUSTERED 
(
	[ExtraId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE TRIGGER [dbo].[RO_SalesDetailExtra_Delete] ON [dbo].[RO_SalesDetailExtra] 
FOR DELETE, UPDATE
AS
	RAISERROR ('Update and Deletions not allowed from this table', 16, 1)

GO
ALTER TABLE [dbo].[RO_SalesDetailExtra] ENABLE TRIGGER [RO_SalesDetailExtra_Delete]
GO
