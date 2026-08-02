SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[L_LaundryDetails](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[LaundryMasterID] [int] NULL,
	[ClothID] [int] NULL,
	[MaterialID] [int] NULL,
	[Color] [nvarchar](max) NULL,
	[Description] [nvarchar](max) NULL,
	[LaundryTypeID] [int] NULL,
	[Quantity] [int] NULL,
	[Rate] [int] NULL,
	[IsDelivered] [bit] NULL,
 CONSTRAINT [PK_L_LaundryDetails] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
