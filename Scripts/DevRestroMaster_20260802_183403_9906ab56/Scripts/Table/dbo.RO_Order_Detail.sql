SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RO_Order_Detail](
	[OrderDetailsID] [int] IDENTITY(1,1) NOT NULL,
	[Quantity] [float] NULL,
	[Rate] [decimal](18, 2) NULL,
	[Amount] [decimal](18, 2) NULL,
	[Date] [datetime] NULL,
	[IsCancelled] [bit] NULL,
	[ItemId] [int] NULL,
	[OrderMasterId] [int] NOT NULL,
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
	[AddedBy] [nvarchar](250) NULL,
	[OrderNo] [int] NULL,
	[HsCode] [nvarchar](250) NULL,
 CONSTRAINT [PK_RO_Order_Detail] PRIMARY KEY CLUSTERED 
(
	[OrderDetailsID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
CREATE NONCLUSTERED INDEX [IX_FK_dbo_Order_Detail_dbo_Items_ItemId] ON [dbo].[RO_Order_Detail]
(
	[ItemId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_FK_dbo_Order_Detail_dbo_OrderMasters_OrderMasterId] ON [dbo].[RO_Order_Detail]
(
	[OrderMasterId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_RO_OrderDetail_ItemID_OrderMasterID] ON [dbo].[RO_Order_Detail]
(
	[ItemId] ASC,
	[OrderMasterId] ASC
)
INCLUDE([Quantity],[Rate]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[RO_Order_Detail] ADD  CONSTRAINT [DF_RO_Order_Detail_SeatNo]  DEFAULT ((1)) FOR [SeatNo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[trg_RO_Order_Detail_SeatNo] ON [dbo].[RO_Order_Detail]
FOR INSERT, UPDATE
AS
IF (SELECT count(1) FROM  INSERTED AS i Where SeatNo=0 or SeatNo is null or SeatNo < 0)>0
BEGIN
 UPDATE a
    SET SeatNo=1
    FROM RO_Order_Detail a
    JOIN inserted i ON a.OrderDetailsID = i.OrderDetailsID

END

GO
ALTER TABLE [dbo].[RO_Order_Detail] ENABLE TRIGGER [trg_RO_Order_Detail_SeatNo]
GO
