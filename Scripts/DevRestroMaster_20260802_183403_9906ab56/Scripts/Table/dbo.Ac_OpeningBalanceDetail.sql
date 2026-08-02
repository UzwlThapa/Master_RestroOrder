SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Ac_OpeningBalanceDetail](
	[AcOpeningId] [int] IDENTITY(1,1) NOT NULL,
	[IsLoyalty] [bit] NULL,
	[MemberShipId] [int] NULL,
	[TranId] [int] NULL,
	[TranDate] [datetime] NULL,
	[OpeningAmt] [decimal](15, 2) NULL,
	[IsDebit] [bit] NULL,
	[AddedOn] [datetime] NULL,
	[AddedBy] [varchar](50) NULL,
	[UpdatedOn] [datetime] NULL,
	[IsArchived] [bit] NULL,
 CONSTRAINT [PK__Ac_Openi__93DF0EAD2246B6B4] PRIMARY KEY CLUSTERED 
(
	[AcOpeningId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
