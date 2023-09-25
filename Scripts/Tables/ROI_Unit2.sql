

CREATE TABLE [dbo].[ROI_Unit2](
	[Unit2ID] [int] NOT NULL,
	[FirstUnit] [int] NOT NULL,
	[Conversion] [int] NOT NULL,
	[SecondUnit] [int] NOT NULL,
	[AddedBy] [nvarchar](256) NULL,
	[AddedOn] [datetime] NULL,
	[UpdatedOn] [datetime] NULL,
	[UpdatedBy] [nvarchar](256) NULL,
	[IsUpdated] [bit] NULL,
	[IsArchived] [bit] NULL CONSTRAINT [DF_ROI_Unit2_IsArchived]  DEFAULT ((0)),
	[ArchivedBy] [nvarchar](256) NULL,
	[ArchivedOn] [datetime] NULL
) ON [PRIMARY]

GO


