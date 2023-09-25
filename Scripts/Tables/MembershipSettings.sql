

CREATE TABLE [dbo].[MembershipSettings](
	[MembershipSettingID] [int] IDENTITY(1,1) NOT NULL,
	[SettingKey] [nvarchar](256) NULL,
	[SettingValue] [nvarchar](50) NULL,
 CONSTRAINT [PK_MembershipSettings] PRIMARY KEY CLUSTERED 
(
	[MembershipSettingID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO


