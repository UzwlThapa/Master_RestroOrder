

CREATE TABLE [dbo].[tbl_ROVaultTotal](
	[TotalID] [int] IDENTITY(1,1) NOT NULL,
	[Balance] [decimal](18, 2) NULL,
	[IsClosing] [bit] NULL,
	[Date] [datetime] NULL,
	[CCID] [int] NULL,
	[DiffAmount] [decimal](18, 2) NULL,
	[ApprovedBy] [nvarchar](50) NULL,
 CONSTRAINT [PK_tbl_ROVaultTotal] PRIMARY KEY CLUSTERED 
(
	[TotalID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO


