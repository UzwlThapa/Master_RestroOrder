SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RO_ItemShiftLog](
	[ItemShiftLogId] [int] IDENTITY(1,1) NOT NULL,
	[FromTable] [int] NULL,
	[FromSplitNo] [int] NULL,
	[ToTable] [int] NULL,
	[ToSplitNo] [int] NULL,
	[ShiftedBy] [nvarchar](max) NULL,
	[ItemId] [int] NULL,
	[Quantity] [float] NULL,
	[IsCombo] [bit] NULL,
	[ShiftedOn] [datetime] NULL,
	[OrderMasterId] [int] NULL,
	[ToOrdermasterId] [int] NULL,
	[ShiftType] [varchar](200) NULL,
PRIMARY KEY CLUSTERED 
(
	[ItemShiftLogId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
