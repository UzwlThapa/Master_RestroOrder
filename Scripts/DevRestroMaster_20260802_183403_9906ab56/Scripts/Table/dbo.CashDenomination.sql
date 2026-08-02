SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CashDenomination](
	[DenominationId] [int] IDENTITY(1,1) NOT NULL,
	[Date] [datetime] NULL,
	[thousand] [int] NULL,
	[fivehundred] [int] NULL,
	[hundred] [int] NULL,
	[fifty] [int] NULL,
	[twenty] [int] NULL,
	[ten] [int] NULL,
	[five] [int] NULL,
	[two] [int] NULL,
	[one] [int] NULL,
 CONSTRAINT [PK_CashDenomination] PRIMARY KEY CLUSTERED 
(
	[DenominationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
