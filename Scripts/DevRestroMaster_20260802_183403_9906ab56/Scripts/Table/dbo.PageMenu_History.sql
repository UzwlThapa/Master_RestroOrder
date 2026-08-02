SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PageMenu_History](
	[OperationDate] [datetime] NOT NULL,
	[OperationType] [char](1) NOT NULL,
	[OperationId] [char](24) NOT NULL,
	[PageMenuID] [int] NULL,
	[PageID] [int] NULL,
	[PortalID] [int] NULL,
	[IsAdmin] [bit] NULL,
	[IsFooter] [bit] NULL,
	[ShowInMenu] [bit] NULL,
	[HistoryID] [int] IDENTITY(1,1) NOT NULL,
 CONSTRAINT [PK_PageMenu_History] PRIMARY KEY CLUSTERED 
(
	[HistoryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
