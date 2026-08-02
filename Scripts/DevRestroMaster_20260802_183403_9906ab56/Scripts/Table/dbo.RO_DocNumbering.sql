SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RO_DocNumbering](
	[DocNumID] [int] IDENTITY(1,1) NOT NULL,
	[Desription] [varchar](128) NULL,
	[Prefix] [varchar](50) NULL,
	[Suffix] [varchar](50) NULL,
	[BodyLength] [int] NULL,
	[TotalLength] [int] NULL,
	[IsPrefillZero] [bit] NULL,
	[StartNo] [int] NULL,
	[EndNo] [int] NULL,
	[CurrentNo] [int] NULL,
 CONSTRAINT [PK_RO_DocNumbering] PRIMARY KEY CLUSTERED 
(
	[DocNumID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
