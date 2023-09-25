
CREATE TABLE [dbo].[ModuleMessage](
	[ModuleMessageID] [int] IDENTITY(1,1) NOT NULL,
	[ModuleID] [int] NULL,
	[Message] [ntext] NULL,
	[Culture] [nvarchar](50) NULL,
	[IsActive] [bit] NULL,
	[MessageType] [int] NULL,
	[MessageMode] [int] NULL,
	[MessagePosition] [int] NULL,
 CONSTRAINT [PK_ModuleMessage] PRIMARY KEY CLUSTERED 
(
	[ModuleMessageID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO


