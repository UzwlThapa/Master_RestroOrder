SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserDetails](
	[UserID] [int] NULL,
	[ProfileID] [int] IDENTITY(1,1) NOT NULL,
	[image] [nvarchar](250) NULL,
	[UserName] [nvarchar](250) NULL,
	[FirstName] [nvarchar](250) NULL,
	[LastName] [nvarchar](250) NULL,
	[FullName] [nvarchar](250) NULL,
	[BirthDate] [datetime] NULL,
	[Location] [nvarchar](50) NULL,
	[AboutYou] [nvarchar](max) NULL,
	[Email] [nvarchar](max) NULL,
	[ResPhone] [nvarchar](50) NULL,
	[Mobile] [nvarchar](50) NULL,
	[Others] [nvarchar](max) NULL,
	[IsDeleted] [bit] NULL,
	[IsModified] [bit] NULL,
	[AddedOn] [datetime] NULL,
	[UpdatedOn] [datetime] NULL,
	[DeletedOn] [datetime] NULL,
	[PortalID] [int] NULL,
	[AddedBy] [nvarchar](256) NULL,
	[UpdatedBy] [nvarchar](256) NULL,
	[DeletedBy] [nvarchar](256) NULL,
	[Gender] [varchar](10) NULL,
 CONSTRAINT [PK_NewUserProfile] PRIMARY KEY CLUSTERED 
(
	[ProfileID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
ALTER TABLE [dbo].[UserDetails] ADD  CONSTRAINT [DF_NewUserProfile_IsDeleted]  DEFAULT ((0)) FOR [IsDeleted]
GO
ALTER TABLE [dbo].[UserDetails] ADD  CONSTRAINT [DF_NewUserProfile_IsModified]  DEFAULT ((0)) FOR [IsModified]
GO
ALTER TABLE [dbo].[UserDetails] ADD  CONSTRAINT [DF_NewUserProfile_AddedOn]  DEFAULT (getdate()) FOR [AddedOn]
GO
ALTER TABLE [dbo].[UserDetails] ADD  CONSTRAINT [DF_NewUserProfile_UpdatedOn]  DEFAULT (getdate()) FOR [UpdatedOn]
GO
ALTER TABLE [dbo].[UserDetails] ADD  CONSTRAINT [DF_NewUserProfile_PortalID]  DEFAULT ((1)) FOR [PortalID]
GO
