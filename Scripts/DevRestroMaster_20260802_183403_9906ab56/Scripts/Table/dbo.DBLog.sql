SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DBLog](
	[DBID] [int] IDENTITY(1,1) NOT NULL,
	[Operation] [varchar](1) NULL,
	[OperationTime] [datetime] NULL,
	[FileNameAndPath] [nvarchar](550) NULL,
	[OperationBy] [nvarchar](256) NULL
) ON [PRIMARY]

GO
ALTER TABLE [dbo].[DBLog] ADD  CONSTRAINT [DF_DBLog_OperationTime]  DEFAULT (getdate()) FOR [OperationTime]
GO
