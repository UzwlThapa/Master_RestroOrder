SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ROI_Unit1](
	[Unit1Id] [int] IDENTITY(1,1) NOT NULL,
	[UnitDescription] [varchar](50) NOT NULL,
	[Symbol] [varchar](50) NOT NULL,
	[AddedBy] [nvarchar](256) NULL,
	[AddedOn] [datetime] NULL,
	[UpdatedOn] [datetime] NULL,
	[UpdatedBy] [nvarchar](256) NULL,
	[IsUpdated] [bit] NULL,
	[IsArchived] [bit] NULL,
	[ArchivedBy] [nvarchar](256) NULL,
	[ArchivedOn] [datetime] NULL,
 CONSTRAINT [PK_ROI_Unit1] PRIMARY KEY CLUSTERED 
(
	[Unit1Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
ALTER TABLE [dbo].[ROI_Unit1] ADD  CONSTRAINT [DF_ROI_Unit1_IsArchived]  DEFAULT ((0)) FOR [IsArchived]
GO
