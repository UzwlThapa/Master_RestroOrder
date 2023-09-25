

CREATE TABLE [dbo].[RO_OrderItemStatus](
	[OrderItemStatusID] [int] IDENTITY(1,1) NOT NULL,
	[OrderDetailID] [int] NULL,
	[StatusID] [int] NULL,
	[TimeStamp] [datetime] NULL,
 CONSTRAINT [PK_RO_OrderItemStatus] PRIMARY KEY CLUSTERED 
(
	[OrderItemStatusID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO


