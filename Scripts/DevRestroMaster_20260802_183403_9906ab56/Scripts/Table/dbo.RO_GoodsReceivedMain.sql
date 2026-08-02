SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RO_GoodsReceivedMain](
	[GMId] [int] IDENTITY(1,1) NOT NULL,
	[GMNo] [varchar](200) NOT NULL,
	[STId] [int] NOT NULL,
	[PostedBy] [varchar](200) NOT NULL,
	[PostedOn] [datetime] NOT NULL,
	[InvoiceNo] [nvarchar](256) NULL,
	[InvoiceDate] [datetime] NULL,
	[vendorId] [int] NULL,
	[paymentMode] [int] NULL,
	[ExtraDiscount] [decimal](10, 2) NULL,
 CONSTRAINT [PK_GoodsReceived] PRIMARY KEY CLUSTERED 
(
	[GMId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
