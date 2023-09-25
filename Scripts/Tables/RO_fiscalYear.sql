

CREATE TABLE [dbo].[RO_fiscalYear](
	[fyId] [int] IDENTITY(1,1) NOT NULL,
	[fyName] [varchar](128) NULL,
	[isActive] [bit] NULL,
	[StartDate] [datetime] NULL,
	[EndDate] [datetime] NULL,
	[FirstSalesMasterID] [int] NULL,
	[AddedBy] [nvarchar](250) NULL,
	[AddedOn] [datetime] NULL CONSTRAINT [DF_RO_fiscalYear_AddedOn]  DEFAULT (getdate()),
	[UpdatedBy] [nvarchar](250) NULL,
	[UpdatedOn] [datetime] NULL,
	[IsDeleted] [bit] NULL CONSTRAINT [DF_RO_fiscalYear_IsDeleted]  DEFAULT ((0)),
 CONSTRAINT [PK_RO_fiscalYear] PRIMARY KEY CLUSTERED 
(
	[fyId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


