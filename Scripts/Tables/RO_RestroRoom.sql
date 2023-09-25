

CREATE TABLE [dbo].[RO_RestroRoom](
	[restroRoomId] [int] IDENTITY(1,1) NOT NULL,
	[restroRoom] [nvarchar](50) NULL,
	[RoomTypeID] [int] NULL,
	[RoomStatusId] [int] NULL,
 CONSTRAINT [PK_RO_RestroRoom] PRIMARY KEY CLUSTERED 
(
	[restroRoomId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[RO_RestroRoom]  WITH CHECK ADD  CONSTRAINT [FK_RO_RestroRoom_Ro_RoomType1] FOREIGN KEY([RoomTypeID])
REFERENCES [dbo].[Ro_RoomType] ([RoomTypeID])
GO

ALTER TABLE [dbo].[RO_RestroRoom] CHECK CONSTRAINT [FK_RO_RestroRoom_Ro_RoomType1]
GO


