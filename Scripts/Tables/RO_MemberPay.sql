
CREATE TABLE [dbo].[RO_MemberPay](
	[MemberPayID] [int] IDENTITY(1,1) NOT NULL,
	[MemberID] [int] NOT NULL,
	[RemainingAmount] [decimal](18, 2) NULL CONSTRAINT [DF_RO_MemberPay_RemainingAmount]  DEFAULT ((0)),
	[PayAmount] [decimal](18, 2) NOT NULL,
	[AddedOn] [datetime] NOT NULL CONSTRAINT [DF_RO_MemberPay_AddedOn]  DEFAULT (getdate()),
	[AddedBy] [nvarchar](256) NOT NULL,
	[IsActive] [bit] NOT NULL CONSTRAINT [DF_RO_MemberPay_IsActive]  DEFAULT ((0)),
 CONSTRAINT [PK_RO_MemberPay] PRIMARY KEY CLUSTERED 
(
	[MemberPayID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO


