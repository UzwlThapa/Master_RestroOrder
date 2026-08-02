SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[H_HouseKeeping](
	[HK_ID] [int] IDENTITY(1,1) NOT NULL,
	[RoomID] [int] NULL,
	[RoomType] [nvarchar](250) NULL,
	[Room] [varchar](128) NULL,
	[RoomStatus] [nvarchar](50) NULL,
	[Availability] [nvarchar](50) NULL,
	[HK_Date] [varchar](128) NULL,
	[Remarks_HK] [nvarchar](500) NULL,
	[AssignTo] [nvarchar](150) NULL,
	[IsActive] [bit] NULL,
 CONSTRAINT [PK_HK_HouseKeeping] PRIMARY KEY CLUSTERED 
(
	[HK_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
ALTER TABLE [dbo].[H_HouseKeeping] ADD  CONSTRAINT [DF_H_HouseKeeping_IsActive]  DEFAULT ((1)) FOR [IsActive]
GO
