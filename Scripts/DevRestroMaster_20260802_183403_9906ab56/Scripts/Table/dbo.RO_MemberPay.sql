SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RO_MemberPay](
	[MemberPayID] [int] IDENTITY(1,1) NOT NULL,
	[MemberID] [int] NOT NULL,
	[RemainingAmount] [decimal](18, 2) NULL,
	[PayAmount] [decimal](18, 2) NOT NULL,
	[AddedOn] [datetime] NOT NULL,
	[AddedBy] [nvarchar](256) NOT NULL,
	[IsActive] [bit] NOT NULL,
	[GoodReceivedMainId] [int] NULL,
	[SettlementAmount] [decimal](16, 2) NULL,
	[ReturnAmount] [decimal](18, 2) NULL,
 CONSTRAINT [PK_RO_MemberPay] PRIMARY KEY CLUSTERED 
(
	[MemberPayID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
ALTER TABLE [dbo].[RO_MemberPay] ADD  CONSTRAINT [DF_RO_MemberPay_RemainingAmount]  DEFAULT ((0)) FOR [RemainingAmount]
GO
ALTER TABLE [dbo].[RO_MemberPay] ADD  CONSTRAINT [DF_RO_MemberPay_AddedOn]  DEFAULT (getdate()) FOR [AddedOn]
GO
ALTER TABLE [dbo].[RO_MemberPay] ADD  CONSTRAINT [DF_RO_MemberPay_IsActive]  DEFAULT ((0)) FOR [IsActive]
GO
