SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RO_PurchaseReturnMain](
	[PurchaseReturnId] [int] IDENTITY(1,1) NOT NULL,
	[PRNo] [varchar](200) NULL,
	[PostedBy] [varchar](200) NULL,
	[PostedOn] [datetime] NULL,
	[vendorId] [int] NULL,
	[NepaliInvoiceDate] [nvarchar](250) NULL,
	[FyId] [int] NULL,
	[PRNote] [nvarchar](256) NULL,
 CONSTRAINT [PK_RO_PurchaseReturnMain] PRIMARY KEY CLUSTERED 
(
	[PurchaseReturnId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
