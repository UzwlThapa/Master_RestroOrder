SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RO_Agent](
	[MembershipID] [int] IDENTITY(1,1) NOT NULL,
	[Fname] [nvarchar](256) NULL,
	[Lname] [nvarchar](256) NULL,
	[Address] [nvarchar](256) NULL,
	[City] [nvarchar](256) NULL,
	[Country] [nvarchar](256) NULL,
	[TelWork] [nvarchar](256) NULL,
	[TelMobile] [nvarchar](256) NULL,
	[Email] [nvarchar](256) NULL,
	[Company] [nvarchar](256) NULL,
	[DateOfIssue] [nvarchar](256) NULL,
	[DateOfExpire] [nvarchar](256) NULL,
	[Commission] [decimal](18, 2) NULL,
	[PAN] [nvarchar](250) NULL,
	[RemainingBalance] [decimal](18, 2) NULL,
	[UptoNowPaid] [decimal](18, 2) NULL,
	[IsVat] [bit] NULL,
	[FinancialAcId] [int] NULL,
	[AddedBy] [nvarchar](250) NULL,
	[AddedOn] [datetime] NULL,
	[ArchivedBy] [nvarchar](250) NULL,
	[ArchivedOn] [datetime] NULL,
	[UpdatedBy] [nvarchar](250) NULL,
	[UpdatedOn] [datetime] NULL,
	[IsArchived] [bit] NULL,
	[IsAgent] [bit] NULL,
 CONSTRAINT [PK_RO_Agent] PRIMARY KEY CLUSTERED 
(
	[MembershipID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
ALTER TABLE [dbo].[RO_Agent] ADD  CONSTRAINT [DF_RO_Agent_DateOfIssue]  DEFAULT (getdate()) FOR [DateOfIssue]
GO
ALTER TABLE [dbo].[RO_Agent] ADD  CONSTRAINT [DF_RO_Agent_RemainingBalance]  DEFAULT ((0)) FOR [RemainingBalance]
GO
ALTER TABLE [dbo].[RO_Agent] ADD  CONSTRAINT [DF_RO_Agent_UptoNowPaid]  DEFAULT ((0)) FOR [UptoNowPaid]
GO
ALTER TABLE [dbo].[RO_Agent] ADD  CONSTRAINT [DF_RO_Agent_IsVat]  DEFAULT ((0)) FOR [IsVat]
GO
