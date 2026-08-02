SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RO_SalesPaymentMode](
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
	[IsCancelled] [bit] NOT NULL,
	[cancelledBy] [nvarchar](200) NULL,
	[cancelledReasons] [nvarchar](500) NULL,
	[cancelledDate] [nvarchar](200) NULL,
 CONSTRAINT [PK__RO_Sales__1BCA765F28E2F130] PRIMARY KEY CLUSTERED 
(
	[salesPaymentID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
CREATE NONCLUSTERED INDEX [IX_RO_SalesPaymentMode_salesMasterId] ON [dbo].[RO_SalesPaymentMode]
(
	[salesMasterId] ASC
)
INCLUDE([PaymentModeID],[PayAmount],[ReturnPayment],[Customer]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[RO_SalesPaymentMode] ADD  DEFAULT ((0)) FOR [IsCancelled]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[RO_SalesPaymentMode_Delete]
ON [dbo].[RO_SalesPaymentMode]
FOR DELETE, UPDATE
AS
ROLLBACK TRANSACTION;
RAISERROR('Update and Deletions not allowed from this table', 16, 1);

GO
ALTER TABLE [dbo].[RO_SalesPaymentMode] ENABLE TRIGGER [RO_SalesPaymentMode_Delete]
GO
