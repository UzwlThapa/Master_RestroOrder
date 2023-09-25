

CREATE TABLE [dbo].[Log](
	[LogID] [int] IDENTITY(1,1) NOT NULL,
	[LogTypeID] [int] NOT NULL,
	[Severity] [int] NOT NULL,
	[Message] [nvarchar](1000) NOT NULL,
	[Exception] [nvarchar](4000) NOT NULL,
	[ClientIPAddress] [nvarchar](100) NOT NULL,
	[PageURL] [nvarchar](100) NOT NULL,
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
 CONSTRAINT [PK_Log] PRIMARY KEY CLUSTERED 
(
	[LogID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[Log]  WITH CHECK ADD  CONSTRAINT [FK_Log_LogType] FOREIGN KEY([LogTypeID])
REFERENCES [dbo].[LogType] ([LogTypeID])
GO

ALTER TABLE [dbo].[Log] CHECK CONSTRAINT [FK_Log_LogType]
GO


