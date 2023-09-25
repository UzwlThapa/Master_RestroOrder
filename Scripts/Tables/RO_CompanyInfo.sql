

CREATE TABLE [dbo].[RO_CompanyInfo](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](max) NULL,
	[RegistrationNo] [nvarchar](max) NULL,
	[Address] [nvarchar](max) NULL,
	[Country] [nvarchar](max) NULL,
	[Logo] [varchar](128) NULL,
	[PhoneNo] [varchar](128) NULL,
	[PAN] [varchar](128) NULL,
	[CurrencyID] [int] NULL,
 CONSTRAINT [PK_dbo.CompanyInfoes] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


