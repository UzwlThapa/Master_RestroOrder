

CREATE TABLE [dbo].[RO_SalesBillTermDetail](
	[SBTDetailId] [int] IDENTITY(1,1) NOT NULL,
	[SBTMasterId] [int] NULL,
	[BillNo] [nvarchar](128) NULL,
	[BillTermId] [int] NULL,
	[Amount] [decimal](8, 2) NULL,
	[BillDate] [datetime] NULL,
	[BillTerm] [nvarchar](128) NULL,
 CONSTRAINT [PK_RO_SalesBillTermDetail] PRIMARY KEY CLUSTERED 
(
	[SBTDetailId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO


