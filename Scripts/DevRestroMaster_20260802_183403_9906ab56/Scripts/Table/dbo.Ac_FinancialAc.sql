SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Ac_FinancialAc](
	[FinancialAcID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](256) NULL,
	[PFinancialAcID] [int] NULL,
	[FinancialSysID] [int] NULL,
	[AddedBy] [nvarchar](256) NULL,
	[AddedOn] [datetime] NULL,
	[IsUpdated] [bit] NULL,
	[UpdatedOn] [datetime] NULL,
	[UpdatedBy] [nvarchar](256) NULL,
	[IsArchived] [bit] NULL,
	[ArchivedOn] [datetime] NULL,
	[ArchivedBy] [nvarchar](256) NULL,
	[OpeningBalance] [decimal](18, 2) NULL,
	[IsShownInBalanceSheet] [bit] NULL,
	[SystemGenerated] [bit] NULL,
	[AccEntryType] [int] NULL,
	[IsDebit] [bit] NULL,
 CONSTRAINT [PK_Ac_FinancialAc] PRIMARY KEY CLUSTERED 
(
	[FinancialAcID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
ALTER TABLE [dbo].[Ac_FinancialAc] ADD  CONSTRAINT [DF_Ac_FinancialAc_AddedOn]  DEFAULT (getdate()) FOR [AddedOn]
GO
ALTER TABLE [dbo].[Ac_FinancialAc] ADD  CONSTRAINT [DF_Ac_FinancialAc_IsUpdated]  DEFAULT ((0)) FOR [IsUpdated]
GO
ALTER TABLE [dbo].[Ac_FinancialAc] ADD  CONSTRAINT [DF_Ac_FinancialAc_IsArchived]  DEFAULT ((0)) FOR [IsArchived]
GO
