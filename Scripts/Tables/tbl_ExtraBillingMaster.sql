

CREATE TABLE [dbo].[tbl_ExtraBillingMaster](
	[ExtraBillingID] [int] IDENTITY(1,1) NOT NULL,
	[CustomerName] [nvarchar](256) NULL,
	[IssueDate] [nvarchar](256) NULL,
	[Pan] [nvarchar](256) NULL,
	[NetTotal] [nvarchar](256) NULL,
	[Vat] [nvarchar](256) NULL,
	[Discount] [nvarchar](256) NULL,
	[GrandTotal] [nvarchar](256) NULL,
 CONSTRAINT [PK_tbl_ExtraBillingMaster] PRIMARY KEY CLUSTERED 
(
	[ExtraBillingID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO


