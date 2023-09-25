

CREATE TABLE [dbo].[RO_AccountSubGroup](
	[AccountSubGroupId] [int] IDENTITY(1,1) NOT NULL,
	[Code] [nvarchar](16) NOT NULL,
	[Name] [nvarchar](128) NOT NULL,
	[AccountGroupId] [int] NOT NULL,
	[CreatedBy] [nvarchar](64) NULL,
	[CreateDate] [datetime] NULL,
	[LastUpdateBy] [nvarchar](64) NULL,
	[LastUpdateDate] [datetime] NULL,
 CONSTRAINT [PK_Sub_Group_Id] PRIMARY KEY CLUSTERED 
(
	[AccountSubGroupId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [UQ__Sub_Grou__A25C5AA74AB81AF0] UNIQUE NONCLUSTERED 
(
	[Code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[RO_AccountSubGroup]  WITH CHECK ADD  CONSTRAINT [FK_RO_AccountSubGroup_RO_AccountGroup] FOREIGN KEY([AccountGroupId])
REFERENCES [dbo].[RO_AccountGroup] ([AccountGroupID])
GO

ALTER TABLE [dbo].[RO_AccountSubGroup] CHECK CONSTRAINT [FK_RO_AccountSubGroup_RO_AccountGroup]
GO


