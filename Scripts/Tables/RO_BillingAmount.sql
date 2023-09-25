

CREATE TABLE [dbo].[RO_BillingAmount](
	[BAID] [int] IDENTITY(1,1) NOT NULL,
	[BilingID] [int] NULL,
	[SalesMasterID] [int] NULL,
	[Amount] [decimal](18, 2) NULL,
	[IsVoid] [bit] NULL CONSTRAINT [DF_RO_BillingAmount_IsVoid]  DEFAULT ((0)),
	[rate] [decimal](18, 2) NULL,
 CONSTRAINT [PK_RO_BillingAmount] PRIMARY KEY CLUSTERED 
(
	[BAID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO


