SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RO_CAKE_SalesPaymentMode](
	[salesPaymentID] [int] IDENTITY(1,1) NOT NULL,
	[salesMasterId] [int] NULL,
	[PaymentModeID] [int] NULL,
	[ChequeNo] [nvarchar](max) NULL,
	[TransactionNo] [nvarchar](max) NULL,
	[ProviderID] [int] NULL,
	[CusID] [int] NULL,
	[Customer] [nvarchar](max) NULL,
	[Address] [nvarchar](max) NULL,
	[PAN] [nvarchar](max) NULL,
	[PayAmount] [decimal](18, 2) NULL,
	[Remarks] [nvarchar](max) NULL,
	[ReturnPayment] [decimal](18, 2) NULL,
	[SalesType] [nvarchar](30) NULL,
 CONSTRAINT [PK_RO_CAKE_SalesPaymentMode] PRIMARY KEY CLUSTERED 
(
	[salesPaymentID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
