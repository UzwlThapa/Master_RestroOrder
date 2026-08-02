SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserModules_History](
	[OperationDate] [datetime] NOT NULL,
	[OperationType] [char](1) NOT NULL,
	[OperationId] [nvarchar](256) NOT NULL,
	[UserModuleID] [int] NULL,
	[ModuleDefID] [int] NULL,
	[UserModuleTitle] [nvarchar](256) NULL,
	[AllPages] [bit] NULL,
	[InheritViewPermissions] [bit] NULL,
	[Header] [ntext] NULL,
	[Footer] [ntext] NULL,
	[StartDate] [datetime] NULL,
	[EndDate] [datetime] NULL,
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
	[SEOName] [nvarchar](100) NULL,
	[ShowInPages] [nvarchar](256) NULL,
	[IsHandheld] [bit] NULL,
	[SuffixClass] [nvarchar](max) NULL,
	[HeaderText] [nvarchar](500) NULL,
	[ShowHeaderText] [bit] NULL,
	[IsInAdmin] [bit] NULL,
	[HistoryID] [int] IDENTITY(1,1) NOT NULL,
 CONSTRAINT [PK_UserModules_History] PRIMARY KEY CLUSTERED 
(
	[HistoryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
