SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Ac_TempTransaction](
	[TransactionID] [bigint] IDENTITY(1,1) NOT NULL,
	[TransactionDate] [date] NULL,
	[VoucherTypeID] [int] NULL,
	[VoucherNo] [nvarchar](256) NULL,
	[Descriptions] [nvarchar](max) NULL,
	[PostedBy] [nvarchar](250) NULL,
	[PostedOn] [datetime] NULL,
	[UpdatedOn] [datetime] NULL,
	[UpdatedBy] [nvarchar](256) NULL,
	[IsUpdated] [bit] NULL,
	[IsDeleted] [bit] NULL,
	[DeletedBy] [nvarchar](256) NULL,
	[DeletedOn] [datetime] NULL,
	[IsVerified] [bit] NULL,
	[SalesMasterId] [int] NULL,
	[BillDate] [datetime] NULL,
 CONSTRAINT [PK_Ac_TempTransaction] PRIMARY KEY CLUSTERED 
(
	[TransactionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
ALTER TABLE [dbo].[Ac_TempTransaction] ADD  CONSTRAINT [DF_Ac_TempTransaction_IsUpdated]  DEFAULT ((0)) FOR [IsUpdated]
GO
ALTER TABLE [dbo].[Ac_TempTransaction] ADD  CONSTRAINT [DF_Ac_TempTransaction_IsDeleted]  DEFAULT ((0)) FOR [IsDeleted]
GO
ALTER TABLE [dbo].[Ac_TempTransaction] ADD  CONSTRAINT [DF_Ac_TempTransaction_IsVerified]  DEFAULT ((0)) FOR [IsVerified]
GO
