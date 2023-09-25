

CREATE TABLE [dbo].[DBLog](
	[DBID] [int] IDENTITY(1,1) NOT NULL,
	[Operation] [varchar](1) NULL,
	[OperationTime] [datetime] NULL CONSTRAINT [DF_DBLog_OperationTime]  DEFAULT (getdate()),
	[FileNameAndPath] [nvarchar](550) NULL,
	[OperationBy] [nvarchar](256) NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


