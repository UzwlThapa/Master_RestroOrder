

CREATE TABLE [dbo].[Ac_FinancialAc](
	[FinancialAcID] [int] NOT NULL,
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
	[OpeningBalance] [decimal](18, 2) NULL
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[Ac_FinancialAc] ADD  CONSTRAINT [DF_Ac_FinancialAc_AddedOn]  DEFAULT (getdate()) FOR [AddedOn]
GO

ALTER TABLE [dbo].[Ac_FinancialAc] ADD  CONSTRAINT [DF_Ac_FinancialAc_IsUpdated]  DEFAULT ((0)) FOR [IsUpdated]
GO

ALTER TABLE [dbo].[Ac_FinancialAc] ADD  CONSTRAINT [DF_Ac_FinancialAc_IsArchived]  DEFAULT ((0)) FOR [IsArchived]
GO


