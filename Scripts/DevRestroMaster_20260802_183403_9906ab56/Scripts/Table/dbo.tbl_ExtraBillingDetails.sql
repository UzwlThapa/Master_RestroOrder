SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_ExtraBillingDetails](
	[ExtraBillingDetailsID] [int] IDENTITY(1,1) NOT NULL,
	[BillingID] [int] NULL,
	[Item] [nvarchar](256) NULL,
	[Rate] [nvarchar](256) NULL,
	[Quantity] [nvarchar](256) NULL,
	[Total] [nvarchar](256) NULL,
 CONSTRAINT [PK_tbl_ExtraBillingDetails] PRIMARY KEY CLUSTERED 
(
	[ExtraBillingDetailsID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
