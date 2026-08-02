SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Cake_PrintDetail](
	[PrintId] [int] IDENTITY(1,1) NOT NULL,
	[PrintBillNo] [nvarchar](20) NULL,
	[PrintedNumber] [int] NULL,
	[PrintedDate] [datetime] NULL,
	[PrintedBy] [nvarchar](100) NULL,
	[SalesType] [nvarchar](30) NULL
) ON [PRIMARY]

GO
