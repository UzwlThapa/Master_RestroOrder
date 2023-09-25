

CREATE TABLE [dbo].[Dashboard_Roles](
	[RoleID] [uniqueidentifier] NOT NULL,
	[PortalID] [int] NULL,
	[UpdatedOn] [date] NULL,
	[Updatedby] [nvarchar](256) NULL,
	[UserName] [nvarchar](256) NULL,
 CONSTRAINT [PK_Dashboard_Roles] PRIMARY KEY CLUSTERED 
(
	[RoleID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO


