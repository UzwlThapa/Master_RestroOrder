SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblComplementaryMaster](
	[CompMasterID] [int] IDENTITY(1,1) NOT NULL,
	[RoomId] [int] NULL,
	[TableId] [nvarchar](50) NULL,
	[BillNo] [nvarchar](128) NULL,
	[Date] [datetime] NULL,
	[BasicAmount] [decimal](18, 2) NULL,
	[TermAmount] [decimal](18, 2) NULL,
	[NetAmount] [decimal](18, 2) NULL,
	[Remarks] [nvarchar](512) NULL,
	[IsCancelled] [bit] NULL,
	[UserName] [varchar](150) NULL,
	[BillPaid] [bit] NULL,
	[IsSplit] [bit] NULL,
	[GuestNo] [int] NULL,
	[IsPrinted] [bit] NULL,
	[OID] [int] NULL,
	[OrderStatus] [int] NULL,
	[CancelReason] [nvarchar](max) NULL,
	[CancelBy] [nvarchar](250) NULL,
	[CancelDate] [datetime] NULL,
	[Details] [nvarchar](max) NULL,
 CONSTRAINT [PK_tblComplementaryMaster] PRIMARY KEY CLUSTERED 
(
	[CompMasterID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
