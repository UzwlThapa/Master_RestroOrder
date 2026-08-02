SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RO_CakeOrder_Detail](
	[OrderDetailsID] [int] IDENTITY(1,1) NOT NULL,
	[OrderMasterId] [int] NULL,
	[ItemId] [int] NULL,
	[ItemName] [nvarchar](256) NULL,
	[Quantity] [float] NULL,
	[Rate] [decimal](18, 2) NULL,
	[Amount] [decimal](18, 2) NULL,
	[AddedBy] [nvarchar](250) NULL,
	[AddedOn] [datetime] NULL,
	[IsUpdated] [bit] NULL,
	[UpdatedBy] [nvarchar](256) NULL,
	[UpdatedOn] [datetime] NULL,
	[IsArchived] [bit] NULL,
	[ArchivedBy] [nvarchar](256) NULL,
	[ArchivedOn] [datetime] NULL,
	[SalesType] [varchar](30) NULL,
	[CostCenterId] [int] NULL,
 CONSTRAINT [PK_RO_CakeOrder_Detail] PRIMARY KEY CLUSTERED 
(
	[OrderDetailsID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
ALTER TABLE [dbo].[RO_CakeOrder_Detail]  WITH CHECK ADD  CONSTRAINT [FK_CakeOrderMaster_CakeOrderDetail] FOREIGN KEY([OrderMasterId])
REFERENCES [dbo].[RO_CakeOrderMaster] ([OrderMasterID])
GO
ALTER TABLE [dbo].[RO_CakeOrder_Detail] CHECK CONSTRAINT [FK_CakeOrderMaster_CakeOrderDetail]
GO
