SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Lists](
	[EntryID] [int] IDENTITY(1,1) NOT NULL,
	[ListName] [nvarchar](50) NOT NULL,
	[Value] [nvarchar](100) NOT NULL,
	[Text] [nvarchar](150) NOT NULL,
	[ParentID] [int] NOT NULL,
	[Level] [int] NOT NULL,
	[CurrencyCode] [nvarchar](50) NULL,
	[DisplayLocale] [nvarchar](50) NULL,
	[DisplayOrder] [int] NOT NULL,
	[DefinitionID] [int] NOT NULL,
	[Description] [nvarchar](500) NULL,
	[PortalID] [int] NOT NULL,
	[SystemList] [bit] NOT NULL,
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
ALTER TABLE [dbo].[Lists] ADD  CONSTRAINT [DF__Lists__ParentID__53C2623D]  DEFAULT ((0)) FOR [ParentID]
GO
ALTER TABLE [dbo].[Lists] ADD  CONSTRAINT [DF__Lists__Level__54B68676]  DEFAULT ((0)) FOR [Level]
GO
ALTER TABLE [dbo].[Lists] ADD  CONSTRAINT [DF__Lists__SortOrder__55AAAAAF]  DEFAULT ((0)) FOR [DisplayOrder]
GO
ALTER TABLE [dbo].[Lists] ADD  CONSTRAINT [DF__Lists__Definitio__569ECEE8]  DEFAULT ((0)) FOR [DefinitionID]
GO
ALTER TABLE [dbo].[Lists] ADD  CONSTRAINT [DF__Lists__PortalID__5792F321]  DEFAULT ((-1)) FOR [PortalID]
GO
ALTER TABLE [dbo].[Lists] ADD  CONSTRAINT [DF__Lists__SystemLis__5887175A]  DEFAULT ((0)) FOR [SystemList]
GO
