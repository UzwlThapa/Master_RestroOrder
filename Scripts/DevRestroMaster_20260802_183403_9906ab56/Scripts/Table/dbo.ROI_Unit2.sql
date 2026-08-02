SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ROI_Unit2](
	[Unit2ID] [int] IDENTITY(1,1) NOT NULL,
	[FirstUnit] [int] NOT NULL,
	[Conversion] [int] NOT NULL,
	[SecondUnit] [int] NOT NULL,
	[AddedBy] [nvarchar](256) NULL,
	[AddedOn] [datetime] NULL,
	[UpdatedOn] [datetime] NULL,
	[UpdatedBy] [nvarchar](256) NULL,
	[IsUpdated] [bit] NULL,
	[IsArchived] [bit] NULL,
	[ArchivedBy] [nvarchar](256) NULL,
	[ArchivedOn] [datetime] NULL,
 CONSTRAINT [PK_ROI_Unit2] PRIMARY KEY CLUSTERED 
(
	[Unit2ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
ALTER TABLE [dbo].[ROI_Unit2] ADD  CONSTRAINT [DF_ROI_Unit2_IsArchived]  DEFAULT ((0)) FOR [IsArchived]
GO
