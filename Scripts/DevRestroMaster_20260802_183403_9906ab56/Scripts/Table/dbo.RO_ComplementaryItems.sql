SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RO_ComplementaryItems](
	[CompId] [int] IDENTITY(1,1) NOT NULL,
	[Quantity] [float] NULL,
	[Rate] [decimal](18, 2) NULL,
	[Amount] [decimal](18, 2) NULL,
	[IsCancelled] [bit] NULL,
	[ItemId] [int] NULL,
	[Date] [datetime] NULL,
	[CompMasterID] [int] NULL,
	[SeatNo] [int] NULL,
	[Note] [nvarchar](256) NULL,
	[ExtraCharge] [int] NULL,
	[BillPaid] [bit] NULL,
	[NetAmount] [decimal](18, 2) NULL,
	[CostCenterId] [int] NULL,
	[IsRunningOrder] [int] NULL,
	[ROI_ItemId] [int] NULL,
	[IsHomeDelivery] [bit] NULL,
	[HomeDeliveyNumber] [int] NULL,
	[ExtraItem] [nvarchar](max) NULL,
	[IsUpdated] [bit] NULL,
	[UpdatedBy] [nvarchar](256) NULL,
	[UpdatedOn] [datetime] NULL,
	[ArchivedBy] [nvarchar](256) NULL,
	[IsArchived] [bit] NULL,
	[ArchivedOn] [datetime] NULL,
	[IsCombo] [bit] NULL,
	[OrderNo] [int] NULL,
 CONSTRAINT [PK_RO_ComplementaryItems] PRIMARY KEY CLUSTERED 
(
	[CompId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
