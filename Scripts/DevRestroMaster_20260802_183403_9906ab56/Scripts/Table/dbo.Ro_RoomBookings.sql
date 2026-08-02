SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Ro_RoomBookings](
	[RoomBookDetailsID] [int] IDENTITY(1,1) NOT NULL,
	[OrderMasterId] [int] NULL,
	[TableId] [int] NULL,
	[BookedFrom] [datetime] NULL,
	[BookedTo] [datetime] NULL,
	[IsCancelled] [bit] NULL,
	[BookedDays] [int] NULL,
	[Rate] [decimal](18, 2) NULL,
	[TotalAmount] [decimal](18, 2) NULL,
	[AdvancePayment] [decimal](18, 2) NULL,
	[CustomerId] [int] NULL,
	[CustomerName] [nvarchar](max) NULL,
	[PhoneNo] [nvarchar](max) NULL,
	[EmailAddress] [nvarchar](max) NULL,
	[CtznNo] [nvarchar](max) NULL,
	[Remarks] [nvarchar](max) NULL,
 CONSTRAINT [PK_Ro_RoomBookings] PRIMARY KEY CLUSTERED 
(
	[RoomBookDetailsID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
