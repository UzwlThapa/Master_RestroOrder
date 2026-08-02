SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RO_GarbageDetail](
	[GarbageId] [int] IDENTITY(1,1) NOT NULL,
	[ITId] [int] NULL,
	[Quantity] [decimal](10, 2) NULL,
	[OrderDetailsID] [int] NULL,
	[TableId] [int] NULL,
	[Addedby] [varchar](250) NULL,
	[AddedOn] [datetime] NULL,
	[IsCombo] [bit] NULL,
	[Remarks] [nvarchar](max) NULL,
 CONSTRAINT [PK_RO_GarbageDetail] PRIMARY KEY CLUSTERED 
(
	[GarbageId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
