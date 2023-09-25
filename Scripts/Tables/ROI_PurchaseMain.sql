

CREATE TABLE [dbo].[ROI_PurchaseMain](
	[PurchaseMainID] [int] IDENTITY(1,1) NOT NULL,
	[PuNo] [nvarchar](200) NULL,
	[PbDate] [datetime] NULL,
	[IvNo] [nvarchar](200) NULL,
	[Vid] [int] NULL,
	[Remarks] [nvarchar](max) NULL,
	[FyId] [nvarchar](200) NULL,
	[PostedOn] [varchar](100) NULL,
	[PostedBy] [nvarchar](100) NULL,
	[SPMID] [int] NULL,
 CONSTRAINT [PK_ROI_PurchaseMain] PRIMARY KEY CLUSTERED 
(
	[PurchaseMainID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


