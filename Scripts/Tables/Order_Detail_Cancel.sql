

CREATE TABLE [dbo].[Order_Detail_Cancel](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[CanceledBy] [nvarchar](max) NULL,
	[OrderBy] [nvarchar](max) NULL,
	[Item] [nvarchar](max) NULL,
	[Quantity] [int] NULL,
	[Reason] [nvarchar](max) NULL,
	[Date] [datetime] NULL,
	[Responsible] [nvarchar](max) NULL,
 CONSTRAINT [PK_Order_Detail_Cancel] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO


