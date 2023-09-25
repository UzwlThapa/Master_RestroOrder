

CREATE TABLE [dbo].[aspnet_Users](
	[ApplicationId] [uniqueidentifier] NOT NULL,
	[UserId] [uniqueidentifier] NOT NULL CONSTRAINT [DF__aspnet_Us__UserI__27E3DFFF]  DEFAULT (newid()),
	[UserName] [nvarchar](256) NOT NULL,
	[LoweredUserName] [nvarchar](256) NOT NULL,
	[MobileAlias] [nvarchar](16) NULL CONSTRAINT [DF__aspnet_Us__Mobil__28D80438]  DEFAULT (NULL),
	[IsAnonymous] [bit] NOT NULL CONSTRAINT [DF__aspnet_Us__IsAno__29CC2871]  DEFAULT ((0)),
	[LastActivityDate] [datetime] NOT NULL,
 CONSTRAINT [PK__aspnet_Users__25FB978D] PRIMARY KEY NONCLUSTERED 
(
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[aspnet_Users]  WITH CHECK ADD  CONSTRAINT [FK__aspnet_Us__Appli__26EFBBC6] FOREIGN KEY([ApplicationId])
REFERENCES [dbo].[aspnet_Applications] ([ApplicationId])
GO

ALTER TABLE [dbo].[aspnet_Users] CHECK CONSTRAINT [FK__aspnet_Us__Appli__26EFBBC6]
GO


