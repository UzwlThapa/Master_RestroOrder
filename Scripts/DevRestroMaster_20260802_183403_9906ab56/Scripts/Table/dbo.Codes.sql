SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Codes](
	[Code] [uniqueidentifier] NULL,
	[ActiveFrom] [datetime] NULL,
	[ActiveTo] [datetime] NULL,
	[CodeForPurpose] [nvarchar](256) NULL,
	[CodeForUsername] [nchar](256) NULL,
	[IsAlreadyUsed] [bit] NULL,
	[PortalID] [int] NULL,
	[CodeID] [int] IDENTITY(1,1) NOT NULL,
 CONSTRAINT [PK_Codes] PRIMARY KEY CLUSTERED 
(
	[CodeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
ALTER TABLE [dbo].[Codes] ADD  CONSTRAINT [DF_Codes_IsAlreadyUsed]  DEFAULT ((0)) FOR [IsAlreadyUsed]
GO
