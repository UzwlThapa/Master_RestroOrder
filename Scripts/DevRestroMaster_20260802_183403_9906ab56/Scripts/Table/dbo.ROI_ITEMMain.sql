SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ROI_ITEMMain](
	[ITId] [int] IDENTITY(1,1) NOT NULL,
	[ITName] [varchar](250) NOT NULL,
	[PITId] [int] NOT NULL,
	[IsActive] [bit] NULL,
	[IsMenu] [bit] NULL,
	[IsCategory] [bit] NULL,
	[AddedBy] [nvarchar](256) NULL,
	[AddedOn] [datetime] NULL,
	[UpdatedOn] [datetime] NULL,
	[UpdatedBy] [nvarchar](256) NULL,
	[IsUpdated] [bit] NULL,
	[IsArchived] [bit] NULL,
	[ArchivedBy] [nvarchar](256) NULL,
	[ArchivedOn] [datetime] NULL,
	[LookupName] [varchar](20) NULL,
	[HsCode] [nvarchar](10) NULL,
 CONSTRAINT [PK_ITEMMain] PRIMARY KEY CLUSTERED 
(
	[ITId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
ALTER TABLE [dbo].[ROI_ITEMMain] ADD  CONSTRAINT [DF_ITEMMain_PITId]  DEFAULT ((0)) FOR [PITId]
GO
