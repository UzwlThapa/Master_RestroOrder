SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RO_ExtraItem](
	[ExtraItemID] [int] IDENTITY(1,1) NOT NULL,
	[ItemID] [int] NULL,
	[ExtraItem] [nvarchar](200) NULL,
	[ExtraPrice] [decimal](18, 2) NULL,
	[IsActive] [bit] NULL,
	[AddedBy] [nvarchar](256) NULL,
	[AddedOn] [datetime] NULL,
	[UpdatedOn] [datetime] NULL,
	[UpdatedBy] [nvarchar](256) NULL,
	[IsUpdated] [bit] NULL,
	[IsDeleted] [bit] NULL,
	[DeletedBy] [nvarchar](256) NULL,
	[DeletedOn] [datetime] NULL,
 CONSTRAINT [PK_RO_ExtraItem] PRIMARY KEY CLUSTERED 
(
	[ExtraItemID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
