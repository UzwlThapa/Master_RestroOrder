

CREATE TABLE [dbo].[Ac_VoucherType](
	[VoucherTypeID] [int] IDENTITY(1,1) NOT NULL,
	[VoucherName] [nvarchar](250) NULL,
	[Prefix] [nvarchar](10) NULL,
	[FiscalID] [int] NULL,
	[VoucherCount] [int] NULL,
	[IsAutomatic] [bit] NULL,
	[AddedBy] [nvarchar](256) NULL,
	[AddedOn] [datetime] NOT NULL,
	[IsUpdated] [bit] NULL,
	[UpdatedOn] [datetime] NULL,
	[UpdatedBy] [nvarchar](256) NULL,
	[IsArchived] [bit] NULL,
	[ArchivedOn] [datetime] NULL,
	[ArchivedBy] [nvarchar](256) NULL,
 CONSTRAINT [PK_Ac_VoucherType] PRIMARY KEY CLUSTERED 
(
	[VoucherTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[Ac_VoucherType] ADD  CONSTRAINT [DF_Ac_VoucherType_FiscalID]  DEFAULT ((1)) FOR [FiscalID]
GO

ALTER TABLE [dbo].[Ac_VoucherType] ADD  CONSTRAINT [DF_Ac_VoucherType_VoucherCount]  DEFAULT ((0)) FOR [VoucherCount]
GO

ALTER TABLE [dbo].[Ac_VoucherType] ADD  CONSTRAINT [DF_Ac_VoucherType_IsAutomatic]  DEFAULT ((0)) FOR [IsAutomatic]
GO

ALTER TABLE [dbo].[Ac_VoucherType] ADD  CONSTRAINT [DF_Ac_VoucherType_AddedOn]  DEFAULT (getdate()) FOR [AddedOn]
GO

ALTER TABLE [dbo].[Ac_VoucherType] ADD  CONSTRAINT [DF_Ac_VoucherType_IsUpdated]  DEFAULT ((0)) FOR [IsUpdated]
GO

ALTER TABLE [dbo].[Ac_VoucherType] ADD  CONSTRAINT [DF_Ac_VoucherType_IsArchived]  DEFAULT ((0)) FOR [IsArchived]
GO


