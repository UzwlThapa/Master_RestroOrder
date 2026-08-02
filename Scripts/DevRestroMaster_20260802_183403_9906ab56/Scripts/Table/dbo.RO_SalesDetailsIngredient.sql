SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RO_SalesDetailsIngredient](
	[SalesIngredientId] [int] IDENTITY(1,1) NOT NULL,
	[SalesDetailId] [int] NULL,
	[IngredienId] [int] NULL,
	[Quantity] [decimal](10, 2) NULL,
	[UnitId] [int] NULL,
	[ItemId] [int] NULL,
	[CostCenterId] [int] NULL,
	[IsCombo] [bit] NULL,
	[IsArchived] [bit] NULL,
	[salesMasterId] [int] NULL,
 CONSTRAINT [PK_RO_SalesDetailsIngredient] PRIMARY KEY CLUSTERED 
(
	[SalesIngredientId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
