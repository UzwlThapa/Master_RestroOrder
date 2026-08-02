SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RO_fiscalYear](
	[fyId] [int] IDENTITY(1,1) NOT NULL,
	[fyName] [varchar](128) NULL,
	[isActive] [bit] NULL,
	[StartDate] [datetime] NULL,
	[EndDate] [datetime] NULL,
	[FirstSalesMasterID] [int] NULL,
	[AddedBy] [nvarchar](250) NULL,
	[AddedOn] [datetime] NULL,
	[UpdatedBy] [nvarchar](250) NULL,
	[UpdatedOn] [datetime] NULL,
	[IsDeleted] [bit] NULL,
 CONSTRAINT [PK_RO_fiscalYear] PRIMARY KEY CLUSTERED 
(
	[fyId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
CREATE NONCLUSTERED INDEX [IX_RO_fiscalYear_fyId] ON [dbo].[RO_fiscalYear]
(
	[fyId] ASC
)
INCLUDE([fyName],[FirstSalesMasterID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[RO_fiscalYear] ADD  CONSTRAINT [DF_RO_fiscalYear_AddedOn]  DEFAULT (getdate()) FOR [AddedOn]
GO
ALTER TABLE [dbo].[RO_fiscalYear] ADD  CONSTRAINT [DF_RO_fiscalYear_IsDeleted]  DEFAULT ((0)) FOR [IsDeleted]
GO
