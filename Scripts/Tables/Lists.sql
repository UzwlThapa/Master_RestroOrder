

CREATE TABLE [dbo].[Lists](
	[EntryID] [int] IDENTITY(1,1) NOT NULL,
	[ListName] [nvarchar](50) NOT NULL,
	[Value] [nvarchar](100) NOT NULL,
	[Text] [nvarchar](150) NOT NULL,
	[ParentID] [int] NOT NULL CONSTRAINT [DF__Lists__ParentID__53C2623D]  DEFAULT ((0)),
	[Level] [int] NOT NULL CONSTRAINT [DF__Lists__Level__54B68676]  DEFAULT ((0)),
	[CurrencyCode] [nvarchar](50) NULL,
	[DisplayLocale] [nvarchar](50) NULL,
	[DisplayOrder] [int] NOT NULL CONSTRAINT [DF__Lists__SortOrder__55AAAAAF]  DEFAULT ((0)),
	[DefinitionID] [int] NOT NULL CONSTRAINT [DF__Lists__Definitio__569ECEE8]  DEFAULT ((0)),
	[Description] [nvarchar](500) NULL,
	[PortalID] [int] NOT NULL CONSTRAINT [DF__Lists__PortalID__5792F321]  DEFAULT ((-1)),
	[SystemList] [bit] NOT NULL CONSTRAINT [DF__Lists__SystemLis__5887175A]  DEFAULT ((0)),
	[IsActive] [bit] NULL,
	[AddedBy] [nvarchar](256) NULL,
	[AddedOn] [datetime] NULL,
	[UpdatedBy] [nvarchar](256) NULL,
	[UpdatedOn] [datetime] NULL,
	[Culture] [nvarchar](256) NULL,
 CONSTRAINT [PK_Lists] PRIMARY KEY CLUSTERED 
(
	[ListName] ASC,
	[Value] ASC,
	[Text] ASC,
	[ParentID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO


