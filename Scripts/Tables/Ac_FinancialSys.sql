

CREATE TABLE [dbo].[Ac_FinancialSys](
	[FinancialSysID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](256) NULL,
	[IsGroup] [bit] NULL,
	[IsActive] [bit] NULL,
	[Note] [nvarchar](max) NULL,
 CONSTRAINT [PK_Ac_FinancialSys] PRIMARY KEY CLUSTERED 
(
	[FinancialSysID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO


