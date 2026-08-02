SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RO_BillTermDetails](
	[BillTermDetailsID] [int] IDENTITY(1,1) NOT NULL,
	[BilingID] [int] NULL,
	[FromDate] [nvarchar](max) NULL,
	[ToDate] [nvarchar](max) NULL,
	[FromTime] [nvarchar](max) NULL,
	[ToTime] [nvarchar](max) NULL,
	[Sunday] [bit] NULL,
	[Monday] [bit] NULL,
	[Tuesday] [bit] NULL,
	[Wednesday] [bit] NULL,
	[Thursday] [bit] NULL,
	[Friday] [bit] NULL,
	[Saturday] [bit] NULL,
 CONSTRAINT [PK_RO_BillTermDetails] PRIMARY KEY CLUSTERED 
(
	[BillTermDetailsID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
