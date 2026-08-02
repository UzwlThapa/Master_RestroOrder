SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RO_TableReservation](
	[ReservationID] [int] IDENTITY(1,1) NOT NULL,
	[CustomerName] [nvarchar](max) NULL,
	[ReservedDateTime] [datetime] NULL,
	[NoOfPeople] [int] NULL,
	[ReservedOn] [datetime] NULL,
	[ReservedBy] [nvarchar](250) NULL,
	[IsConfirmed] [bit] NULL,
	[ConfirmedBy] [nvarchar](250) NULL,
	[IsCancelled] [bit] NULL,
	[CancelledBy] [nvarchar](250) NULL,
	[CancelledOn] [datetime] NULL,
	[Phone] [nvarchar](50) NULL,
	[NotifyBefore] [int] NULL,
	[Note] [nvarchar](500) NULL,
 CONSTRAINT [PK_RO_TableReservation] PRIMARY KEY CLUSTERED 
(
	[ReservationID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
