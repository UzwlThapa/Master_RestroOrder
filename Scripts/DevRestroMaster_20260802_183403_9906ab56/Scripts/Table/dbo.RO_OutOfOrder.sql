SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RO_OutOfOrder](
	[OutOfOrderID] [int] IDENTITY(1,1) NOT NULL,
	[RoomID] [int] NULL,
	[OO_Status] [nvarchar](150) NULL,
	[FromDate] [nvarchar](150) NULL,
	[ThroughDate] [nvarchar](150) NULL,
	[ReturnAs] [nvarchar](50) NULL,
	[Reason] [nvarchar](500) NULL,
	[OO_Remarks] [nvarchar](500) NULL,
	[IsOutOfOrder] [bit] NULL,
	[IsOutOfService] [bit] NULL,
 CONSTRAINT [PK_RO_OutOfOrder] PRIMARY KEY CLUSTERED 
(
	[OutOfOrderID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
