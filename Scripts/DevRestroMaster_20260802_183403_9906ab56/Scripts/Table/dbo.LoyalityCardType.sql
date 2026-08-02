SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LoyalityCardType](
	[CardTypeID] [int] IDENTITY(1,1) NOT NULL,
	[CardName] [nvarchar](250) NULL,
	[Description] [nvarchar](max) NULL,
	[discount] [decimal](18, 2) NULL,
	[AddedOn] [datetime] NULL,
	[IsArchived] [bit] NULL,
	[ArchivedOn] [datetime] NULL,
 CONSTRAINT [PK_LoyalityCardType] PRIMARY KEY CLUSTERED 
(
	[CardTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
