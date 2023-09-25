

CREATE TABLE [dbo].[tbl_CusOrder](
	[OrderID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](256) NULL,
	[OrderDate] [nvarchar](256) NULL,
	[OrderTime] [nvarchar](256) NULL,
	[AppoinmentReceiveTime] [nvarchar](256) NULL,
	[AppoinmentReceiveDate] [nvarchar](256) NULL,
	[OrderModulID] [int] NULL,
	[CellNo] [nvarchar](50) NULL,
	[isTakeAwayhome] [bit] NULL,
	[FullAddress] [nvarchar](max) NULL,
	[Message] [nvarchar](500) NULL,
	[People] [int] NULL,
 CONSTRAINT [PK_tbl_CusOrder] PRIMARY KEY CLUSTERED 
(
	[OrderID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO


