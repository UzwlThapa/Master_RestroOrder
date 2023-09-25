

CREATE TABLE [dbo].[RO_BillTerm](
	[BilingID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](128) NULL,
	[IsAdd] [bit] NULL,
	[Rate] [decimal](18, 0) NULL,
	[Description] [varchar](128) NULL,
	[SequenceOrder] [int] NULL,
	[IsAlwaysActive] [bit] NULL,
 CONSTRAINT [PK_RO_BillTerm] PRIMARY KEY CLUSTERED 
(
	[BilingID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


