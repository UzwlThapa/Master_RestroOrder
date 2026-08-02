SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RO_PurchaseReturnPaymentMode](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[PurchaseReturnId] [int] NULL,
	[paymentModeID] [int] NULL,
	[ChequeNo] [nvarchar](250) NULL,
	[TransactionNo] [nvarchar](250) NULL,
	[ProviderID] [int] NULL,
	[VendorId] [int] NULL,
	[PayAmount] [decimal](18, 2) NULL,
	[Remarks] [nvarchar](max) NULL,
 CONSTRAINT [PK_RO_PurchaseReturnPaymentMode] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
