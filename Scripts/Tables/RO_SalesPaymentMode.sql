

CREATE TABLE [dbo].[RO_SalesPaymentMode](
	[salesPamentID] [int] IDENTITY(1,1) NOT NULL,
	[salesMasterId] [int] NULL,
	[BillNo] [nvarchar](max) NULL,
	[BillAmount] [decimal](18, 2) NULL,
	[SPMID] [nvarchar](max) NULL,
	[ChequeNo] [nvarchar](max) NULL,
	[TransactionNo] [nvarchar](max) NULL,
	[ProviderID] [int] NULL,
	[CusID] [int] NULL,
	[Customer] [nvarchar](max) NULL,
	[Address] [nvarchar](max) NULL,
	[PAN] [nvarchar](max) NULL,
	[BillPaid] [bit] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO


