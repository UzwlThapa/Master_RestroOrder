SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RO_CustomerBillLog](
	[BillLogId] [int] IDENTITY(1,1) NOT NULL,
	[BillDate] [datetime] NULL,
	[CustomerID] [int] NULL,
	[BillAmount] [decimal](18, 2) NULL,
	[CashPaid] [decimal](18, 2) NULL,
	[DiscountCoupon] [int] NULL,
	[Balance] [decimal](18, 2) NULL,
	[BillNo] [nvarchar](max) NULL,
 CONSTRAINT [PK_RO_CustomerBillLog] PRIMARY KEY CLUSTERED 
(
	[BillLogId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
