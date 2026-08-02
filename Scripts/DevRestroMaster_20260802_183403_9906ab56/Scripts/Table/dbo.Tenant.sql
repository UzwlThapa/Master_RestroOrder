SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Tenant](
	[TenantId] [uniqueidentifier] NOT NULL,
	[CompanyCode] [varchar](200) NOT NULL,
	[ValidFrom] [smalldatetime] NOT NULL,
	[ValidTo] [smalldatetime] NOT NULL,
	[CreatedDate] [smalldatetime] NOT NULL,
	[ModifiedDate] [smalldatetime] NOT NULL
) ON [PRIMARY]

GO
ALTER TABLE [dbo].[Tenant] ADD  DEFAULT (newid()) FOR [TenantId]
GO
ALTER TABLE [dbo].[Tenant] ADD  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[Tenant] ADD  DEFAULT (getdate()) FOR [ModifiedDate]
GO
