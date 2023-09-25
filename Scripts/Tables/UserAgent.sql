

CREATE TABLE [dbo].[UserAgent](
	[AgentMode] [nvarchar](50) NULL,
	[PortalID] [int] NULL,
	[ChangedBy] [nvarchar](250) NULL,
	[ChangedDate] [datetime] NULL,
	[IsActive] [bit] NULL,
	[AgentID] [int] IDENTITY(1,1) NOT NULL,
 CONSTRAINT [PK_UserAgent] PRIMARY KEY CLUSTERED 
(
	[AgentID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO


