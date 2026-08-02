SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Ro_AdjustmentType](
	[AdjustmentTypeID] [int] IDENTITY(1,1) NOT NULL,
	[AdjustmentTypeName] [nvarchar](max) NULL,
	[IsActive] [bit] NULL,
	[AddedBy] [nvarchar](max) NULL,
	[AddedOn] [datetime] NULL,
	[UpdatedBy] [nvarchar](max) NULL,
	[UpdatedOn] [datetime] NULL,
	[DeletedBy] [nvarchar](50) NULL,
	[DeletedOn] [datetime] NULL,
	[IsDeleted] [int] NULL,
 CONSTRAINT [PK_Ro_AdjustmentType] PRIMARY KEY CLUSTERED 
(
	[AdjustmentTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
