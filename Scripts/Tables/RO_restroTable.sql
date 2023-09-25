

CREATE TABLE [dbo].[RO_restroTable](
	[restrotableId] [int] IDENTITY(1,1) NOT NULL,
	[restrotableTitle] [varchar](128) NOT NULL,
	[restroRoomId] [int] NULL,
	[restrotablesStatusID] [int] NULL,
	[Seatcap] [int] NULL,
 CONSTRAINT [PK__RO_restr__4A58D9675911273F] PRIMARY KEY CLUSTERED 
(
	[restrotableId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[RO_restroTable]  WITH CHECK ADD  CONSTRAINT [FK_RO_restroTable_RO_RestroRoom] FOREIGN KEY([restroRoomId])
REFERENCES [dbo].[RO_RestroRoom] ([restroRoomId])
GO

ALTER TABLE [dbo].[RO_restroTable] CHECK CONSTRAINT [FK_RO_restroTable_RO_RestroRoom]
GO


