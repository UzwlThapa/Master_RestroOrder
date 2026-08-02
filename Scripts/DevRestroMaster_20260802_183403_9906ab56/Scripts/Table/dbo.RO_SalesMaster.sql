SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RO_SalesMaster](
	[salesMasterId] [int] IDENTITY(1,1) NOT NULL,
	[FiscalYearID] [int] NULL,
	[billNo] [varchar](128) NULL,
	[BillDate] [datetime] NULL,
	[RoomId] [int] NULL,
	[TableId] [int] NULL,
	[BasicAmount] [decimal](18, 2) NULL,
	[TermAmount] [decimal](18, 2) NULL,
	[NetAmount] [decimal](18, 2) NULL,
	[OrderMasterId] [int] NULL,
	[Waiter] [varchar](128) NULL,
	[totaldiscount] [decimal](18, 2) NULL,
	[sumBev] [decimal](18, 2) NULL,
	[sumKot] [decimal](18, 2) NULL,
	[disKot] [decimal](18, 2) NULL,
	[disBar] [decimal](18, 2) NULL,
	[SPMID] [int] NULL,
	[ProviderID] [int] NULL,
	[CusName] [nvarchar](256) NULL,
	[CusID] [int] NULL,
	[PrintCount] [int] NULL,
	[PrintDate] [datetime] NULL,
	[IsArchived] [bit] NULL,
	[ArchivedBy] [nvarchar](max) NULL,
	[ArchivedOn] [datetime] NULL,
	[IsUpdated] [bit] NULL,
	[UpdatedBy] [nvarchar](max) NULL,
	[UpdatedOn] [datetime] NULL,
	[Reasons] [nvarchar](max) NULL,
	[AddedBy] [nvarchar](256) NULL,
	[AddedOn] [datetime] NULL,
	[IsSplit] [int] NULL,
	[SeatNo] [int] NULL,
	[PAN] [varchar](250) NULL,
	[ChequeNO] [varchar](250) NULL,
	[TransactionNo] [varchar](250) NULL,
	[Address] [nvarchar](250) NULL,
	[InvoiceNo] [int] NULL,
	[RoomRate] [decimal](18, 2) NULL,
	[BookedDays] [decimal](18, 2) NULL,
	[RoomCharge] [decimal](18, 2) NULL,
	[AdvancePayment] [decimal](18, 2) NULL,
	[TenderAmount] [decimal](18, 2) NULL,
	[ReturnAmount] [decimal](18, 2) NULL,
	[NepaliInvoiceDate] [nvarchar](max) NULL,
	[sumBakery] [decimal](18, 2) NULL,
	[sumPizza] [decimal](18, 2) NULL,
	[DeliveryCharge] [decimal](18, 2) NULL,
	[DeliveredBy] [nvarchar](250) NULL,
	[PhoneNumber] [varchar](20) NULL,
	[BillCancelled] [bit] NULL,
 CONSTRAINT [PK_RO_SalesMaster] PRIMARY KEY CLUSTERED 
(
	[salesMasterId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
CREATE NONCLUSTERED INDEX [IX_RO_SalesMaster_BillDate_Status] ON [dbo].[RO_SalesMaster]
(
	[BillDate] ASC,
	[IsUpdated] ASC
)
INCLUDE([CusName],[NetAmount],[AdvancePayment],[InvoiceNo],[OrderMasterId],[BasicAmount],[totaldiscount],[PrintCount],[BillCancelled],[IsArchived]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_RO_SalesMaster_FiscalYearID] ON [dbo].[RO_SalesMaster]
(
	[FiscalYearID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[RO_SalesMaster] ADD  CONSTRAINT [DF_RO_SalesMaster_AddedOn]  DEFAULT (getdate()) FOR [AddedOn]
GO
ALTER TABLE [dbo].[RO_SalesMaster] ADD  CONSTRAINT [DF__RO_SalesM__BillC__1F798287]  DEFAULT ((0)) FOR [BillCancelled]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[RO_SalesMaster_Delete] ON [dbo].[RO_SalesMaster] 
FOR DELETE
AS
ROLLBACK TRANSACTION
	RAISERROR ('Update and Deletions not allowed from this table', 16, 1)

GO
ALTER TABLE [dbo].[RO_SalesMaster] ENABLE TRIGGER [RO_SalesMaster_Delete]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE TRIGGER [dbo].[RO_SalesMaster_UPDATE]
ON [dbo].[RO_SalesMaster]
FOR UPDATE
AS

--IF EXISTS(SELECT * FROM DELETED WHERE IsArchived=1 OR IsUpdated=1)
--BEGIN
--RAISERROR ('Update and Deletions not allowed from this table' , 16, 1)
--END

IF
(
    SELECT COUNT(1)
    FROM INSERTED AS i
        INNER JOIN DELETED AS d
            ON i.salesMasterId = d.salesMasterId
               AND i.FiscalYearID = d.FiscalYearID
               AND i.billNo = d.billNo
               AND i.BillDate = d.BillDate
               AND i.RoomId = d.RoomId
               AND i.TableId = d.TableId
               AND i.BasicAmount = d.BasicAmount
               AND i.TermAmount = d.TermAmount
               AND i.NetAmount = d.NetAmount
               AND i.OrderMasterId = d.OrderMasterId
               AND i.Waiter = d.Waiter
               AND i.totaldiscount = d.totaldiscount
               AND i.sumBev = d.sumBev
               AND i.sumKot = d.sumKot
               AND ISNULL(i.disKot, 0) = ISNULL(d.disKot, 0)
               AND ISNULL(i.disBar, 0) = ISNULL(d.disBar, 0)
               --AND i.PrintDate=d.PrintDate
               AND ISNULL(i.AddedBy, '') = ISNULL(d.AddedBy, '')
               AND i.AddedOn = d.AddedOn
               AND i.IsSplit = d.IsSplit
               AND i.SeatNo = d.SeatNo --AND i.InvoiceNo=d.InvoiceNo 
               AND i.RoomRate = d.RoomRate
               AND i.BookedDays = d.BookedDays
               AND i.RoomCharge = d.RoomCharge
               AND i.AdvancePayment = d.AdvancePayment
               AND ISNULL(i.NepaliInvoiceDate, 0) = ISNULL(d.NepaliInvoiceDate, 0)
) = 0
BEGIN
    ROLLBACK TRANSACTION;
    RAISERROR('Update and Deletions not allowed from this table', 16, 1);
END;

GO
ALTER TABLE [dbo].[RO_SalesMaster] ENABLE TRIGGER [RO_SalesMaster_UPDATE]
GO
