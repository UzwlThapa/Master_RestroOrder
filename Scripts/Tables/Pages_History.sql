
CREATE TABLE [dbo].[Pages_History](
	[OperationDate] [datetime] NOT NULL,
	[OperationType] [char](1) NOT NULL,
	[OperationId] [char](24) NOT NULL,
	[PageID] [int] NOT NULL,
	[PageOrder] [int] NULL,
	[PageName] [nvarchar](100) NULL,
	[IsVisible] [bit] NULL,
	[ParentID] [int] NULL,
	[Level] [int] NULL,
	[IconFile] [nvarchar](100) NULL,
	[DisableLink] [bit] NULL,
	[Title] [nvarchar](200) NULL,
	[Description] [nvarchar](500) NULL,
	[KeyWords] [nvarchar](500) NULL,
	[Url] [nvarchar](255) NULL,
	[TabPath] [nvarchar](255) NULL,
	[StartDate] [datetime] NULL,
	[EndDate] [datetime] NULL,
	[RefreshInterval] [decimal](16, 2) NULL,
	[PageHeadText] [nvarchar](500) NULL,
	[IsSecure] [bit] NOT NULL,
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
	[IsShowInFooter] [bit] NULL,
	[IsRequiredPage] [bit] NULL,
	[DasboardGroup] [int] NULL,
	[HistoryID] [int] IDENTITY(1,1) NOT NULL,
 CONSTRAINT [PK_Pages_History] PRIMARY KEY CLUSTERED 
(
	[HistoryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


