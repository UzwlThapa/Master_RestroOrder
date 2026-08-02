SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RO_VendorPurchase](
	[VendorPurchaseId] [int] IDENTITY(1,1) NOT NULL,
	[RecqId] [int] NULL,
	[RecqDetailId] [int] NULL,
	[VendorId] [int] NOT NULL,
	[AddedOn] [datetime] NULL,
	[AddedBy] [nvarchar](50) NULL,
	[DeletedOn] [datetime] NULL,
	[DeletedBy] [nvarchar](50) NULL,
	[IsDeleted] [bit] NULL,
	[IsPOCreated] [bit] NULL,
 CONSTRAINT [PK_RO_VendorPurchase] PRIMARY KEY CLUSTERED 
(
	[VendorPurchaseId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
