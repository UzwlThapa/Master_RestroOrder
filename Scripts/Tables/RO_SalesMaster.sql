

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
	[AddedOn] [datetime] NULL CONSTRAINT [DF_RO_SalesMaster_AddedOn]  DEFAULT (getdate()),
	[IsSplit] [int] NULL,
	[SeatNo] [int] NULL,
	[PAN] [varchar](250) NULL,
	[ChequeNO] [varchar](250) NULL,
	[TransactionNo] [varchar](250) NULL,
	[Address] [nvarchar](250) NULL,
	[InvoiceNo] [int] NULL,
 CONSTRAINT [PK_RO_SalesMaster] PRIMARY KEY CLUSTERED 
(
	[salesMasterId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


