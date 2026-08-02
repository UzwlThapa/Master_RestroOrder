SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RO_CakeSalesMaster](
	[SalesMasterId] [int] IDENTITY(1,1) NOT NULL,
	[FiscalYearID] [int] NULL,
	[BillNo] [varchar](128) NULL,
	[BillDate] [datetime] NULL,
	[OrderMasterId] [int] NULL,
	[CustomerId] [int] NULL,
	[CustomerName] [varchar](250) NULL,
	[ContactNo] [nvarchar](15) NULL,
	[PAN] [varchar](250) NULL,
	[Address] [nvarchar](250) NULL,
	[BasicAmount] [decimal](18, 2) NULL,
	[TermAmount] [decimal](18, 2) NULL,
	[NetAmount] [decimal](18, 2) NULL,
	[AdvancePayment] [decimal](18, 2) NULL,
	[TenderAmount] [decimal](18, 2) NULL,
	[ReturnAmount] [decimal](18, 2) NULL,
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
	[InvoiceNo] [int] NULL,
	[NepaliInvoiceDate] [nvarchar](max) NULL,
	[SalesType] [nvarchar](20) NULL,
PRIMARY KEY CLUSTERED 
(
	[SalesMasterId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
CREATE NONCLUSTERED INDEX [IX_CakeSalesMaster_InvoiceNo] ON [dbo].[RO_CakeSalesMaster]
(
	[InvoiceNo] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[RO_CakeSalesMaster]  WITH CHECK ADD  CONSTRAINT [FK_CakeOrderMaster_CakeSalesMaster] FOREIGN KEY([OrderMasterId])
REFERENCES [dbo].[RO_CakeOrderMaster] ([OrderMasterID])
GO
ALTER TABLE [dbo].[RO_CakeSalesMaster] CHECK CONSTRAINT [FK_CakeOrderMaster_CakeSalesMaster]
GO
