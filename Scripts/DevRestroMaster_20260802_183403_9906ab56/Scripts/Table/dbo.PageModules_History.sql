SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PageModules_History](
	[OperationDate] [datetime] NOT NULL,
	[OperationType] [char](1) NOT NULL,
	[OperationId] [char](24) NOT NULL,
	[PageModuleID] [int] NULL,
	[PageID] [int] NULL,
	[UserModuleID] [int] NULL,
	[PaneName] [nvarchar](50) NULL,
	[ModuleOrder] [int] NULL,
	[CacheTime] [int] NULL,
	[Alignment] [nvarchar](50) NULL,
	[Color] [nvarchar](20) NULL,
	[Border] [nvarchar](1) NULL,
	[IconFile] [nvarchar](100) NULL,
	[Visibility] [int] NULL,
	[DisplayTitle] [bit] NULL,
	[DisplayPrint] [bit] NULL,
	[IsActive] [bit] NULL,
	[IsDeleted] [bit] NULL,
	[IsModified] [bit] NULL,
	[AddedOn] [datetime] NULL,
	[UpdatedOn] [datetime] NULL,
	[DeletedOn] [datetime] NULL,
	[PortalID] [int] NULL,
	[AddedBy] [nvarchar](256) NULL,
	[UpdatedBy] [nvarchar](256) NULL,
	[DeletedBy] [nvarchar](256) NULL,
	[HistoryID] [int] IDENTITY(1,1) NOT NULL,
 CONSTRAINT [PK_PageModules_History] PRIMARY KEY CLUSTERED 
(
	[HistoryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
