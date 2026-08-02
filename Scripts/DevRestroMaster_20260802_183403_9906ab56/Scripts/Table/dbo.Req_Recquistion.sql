SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Req_Recquistion](
	[RecqId] [int] IDENTITY(1,1) NOT NULL,
	[RecqNo] [nvarchar](max) NULL,
	[StoreId] [int] NULL,
	[ParentStore] [int] NULL,
	[RequestedBy] [nvarchar](max) NULL,
	[RequestedOn] [datetime] NULL,
	[StatusId] [int] NULL,
	[IsDeleted] [bit] NULL,
	[DeletedBy] [nvarchar](max) NULL,
	[DeletedOn] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[RecqId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
