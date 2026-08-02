SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ROI_Store](
	[STId] [int] IDENTITY(1,1) NOT NULL,
	[StName] [varchar](50) NOT NULL,
	[PSTId] [int] NOT NULL,
	[Hirerchy] [varchar](250) NULL,
	[IsActive] [bit] NOT NULL,
	[IsDeleted] [bit] NOT NULL,
	[AddedBy] [nvarchar](256) NULL,
	[AddedOn] [datetime] NULL,
	[DeletedBy] [nvarchar](256) NULL,
	[DeletedOn] [datetime] NULL,
	[ModifiedBy] [nvarchar](256) NULL,
	[ModifiedOn] [datetime] NULL,
 CONSTRAINT [PK_Store] PRIMARY KEY CLUSTERED 
(
	[STId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
ALTER TABLE [dbo].[ROI_Store] ADD  CONSTRAINT [DF_ROI_Store_IsActive]  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[ROI_Store] ADD  CONSTRAINT [DF_ROI_Store_IsDeleted]  DEFAULT ((0)) FOR [IsDeleted]
GO
ALTER TABLE [dbo].[ROI_Store] ADD  CONSTRAINT [DF_ROI_Store_AddedOn]  DEFAULT (getdate()) FOR [AddedOn]
GO
