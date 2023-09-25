

CREATE TABLE [dbo].[RO_Currency](
	[CurrencyID] [int] IDENTITY(1,1) NOT NULL,
	[CurrencyName] [nvarchar](50) NULL,
	[SubCurrencyName] [nvarchar](50) NULL,
	[CurrencyIcon] [nchar](10) NULL,
 CONSTRAINT [PK_RO_Currency] PRIMARY KEY CLUSTERED 
(
	[CurrencyID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO


