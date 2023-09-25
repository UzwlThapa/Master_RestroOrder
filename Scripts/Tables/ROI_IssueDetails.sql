

CREATE TABLE [dbo].[ROI_IssueDetails](
	[IDId] [int] IDENTITY(1,1) NOT NULL,
	[IMId] [int] NOT NULL,
	[ITID] [int] NOT NULL,
	[UsedUnitId] [int] NOT NULL,
	[Qnty] [bigint] NOT NULL,
	[QntyInText] [varchar](250) NOT NULL,
	[ReceivedBy] [varchar](250) NULL,
	[ReceivedOn] [datetime] NULL,
 CONSTRAINT [PK_IssueDetails] PRIMARY KEY CLUSTERED 
(
	[IDId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


