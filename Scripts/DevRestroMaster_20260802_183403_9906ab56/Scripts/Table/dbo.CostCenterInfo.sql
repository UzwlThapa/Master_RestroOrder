SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CostCenterInfo](
	[CostCenterId] [int] IDENTITY(1,1) NOT NULL,
	[CostCenterName] [nvarchar](50) NULL,
	[CostCenterAddedDate] [datetime] NULL,
	[CostCenterAddedBy] [nvarchar](50) NULL,
	[DefaultPrinter] [nvarchar](50) NULL,
	[coDiscount] [decimal](18, 2) NULL,
	[NumberOfCounter] [int] NULL,
	[StoreId] [int] NULL,
	[GroupId] [int] NULL,
 CONSTRAINT [PK_dbo_CostCenterInfo] PRIMARY KEY CLUSTERED 
(
	[CostCenterId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
