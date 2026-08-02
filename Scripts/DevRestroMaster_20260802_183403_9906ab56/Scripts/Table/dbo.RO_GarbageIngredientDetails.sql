SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RO_GarbageIngredientDetails](
	[GarbageIngDetailId] [int] IDENTITY(1,1) NOT NULL,
	[IngredientId] [int] NULL,
	[Quantity] [decimal](10, 2) NULL,
	[Unit] [int] NULL,
	[ItemCostCentreID] [int] NULL,
	[GarbageDetailId] [int] NULL,
	[ITId] [int] NULL,
	[IsCombo] [bit] NULL,
 CONSTRAINT [PK_RO_GarbageIngredientDetails] PRIMARY KEY CLUSTERED 
(
	[GarbageIngDetailId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
