
CREATE TABLE [dbo].[L_LaundryMaster](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[RoomTypeID] [int] NULL,
	[RoomID] [int] NULL,
	[CustomerID] [int] NULL,
	[Date] [date] NULL,
	[DeliveryDate] [date] NULL,
	[ChallanNo] [int] NULL,
	[HouseKeeperID] [nvarchar](50) NULL,
	[IsDelivered] [bit] NULL,
	[Amount] [decimal](18, 0) NULL,
	[DiscountType] [nvarchar](max) NULL,
	[Discount] [decimal](18, 0) NULL,
	[Total] [decimal](18, 0) NULL,
 CONSTRAINT [PK_L_LaundryMaster] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
