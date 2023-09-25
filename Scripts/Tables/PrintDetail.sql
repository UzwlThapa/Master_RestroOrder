
CREATE TABLE [dbo].[PrintDetail](
	[PrintId] [int] IDENTITY(1,1) NOT NULL,
	[PrintBillNo] [nvarchar](max) NULL,
	[PrintedNumber] [int] NULL,
	[PrintedDate] [datetime] NULL,
	[PrintedBy] [nvarchar](max) NULL,
 CONSTRAINT [PK_PrintDetail] PRIMARY KEY CLUSTERED 
(
	[PrintId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO


