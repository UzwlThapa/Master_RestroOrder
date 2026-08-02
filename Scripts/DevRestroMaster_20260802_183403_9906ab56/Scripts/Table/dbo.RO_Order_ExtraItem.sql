SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RO_Order_ExtraItem](
	[ExtraOrderID] [int] IDENTITY(1,1) NOT NULL,
	[OrderMasterId] [int] NULL,
	[OrderDetailsID] [int] NULL,
	[ItemID] [int] NULL,
	[ExtraItemID] [int] NULL,
	[ExtraItem] [nvarchar](256) NULL,
	[Quantity] [int] NULL,
	[ExtraPrice] [decimal](18, 2) NULL,
	[SeatNo] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[ExtraOrderID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
