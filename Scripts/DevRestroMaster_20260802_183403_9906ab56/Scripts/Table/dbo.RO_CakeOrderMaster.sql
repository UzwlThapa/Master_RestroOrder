SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RO_CakeOrderMaster](
	[OrderMasterID] [int] IDENTITY(1,1) NOT NULL,
	[BillNo] [nvarchar](128) NULL,
	[Date] [datetime] NULL,
	[Remarks] [nvarchar](512) NULL,
	[CustomerId] [int] NULL,
	[CustomerName] [nvarchar](50) NULL,
	[Phone] [nvarchar](50) NULL,
	[Address] [nvarchar](150) NULL,
	[PAN] [nvarchar](9) NULL,
	[StatusId] [int] NULL,
	[AdvanceAmount] [decimal](18, 2) NULL,
	[DeliveryTime] [datetime] NULL,
	[DeliveryService] [varchar](20) NULL,
	[CancelReason] [nvarchar](max) NULL,
	[AddedBy] [nvarchar](256) NULL,
	[AddedOn] [datetime] NULL,
	[UpdatedBy] [nvarchar](256) NULL,
	[UpdatedOn] [datetime] NULL,
	[SalesType] [varchar](30) NULL,
	[OrderNo] [int] NULL,
	[OrderTypeID] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[OrderMasterID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
