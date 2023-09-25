

CREATE TABLE [dbo].[ROI_Unit1](
	[Unit1Id] [int] NOT NULL,
	[UnitDescription] [varchar](50) NOT NULL,
	[Symbol] [char](10) NOT NULL,
	[AddedBy] [nvarchar](256) NULL,
	[AddedOn] [datetime] NULL,
	[UpdatedOn] [datetime] NULL,
	[UpdatedBy] [nvarchar](256) NULL,
	[IsUpdated] [bit] NULL,
	[IsArchived] [bit] NULL CONSTRAINT [DF_ROI_Unit1_IsArchived]  DEFAULT ((0)),
	[ArchivedBy] [nvarchar](256) NULL,
	[ArchivedOn] [datetime] NULL,
 CONSTRAINT [PK_ROI_Unit1] PRIMARY KEY CLUSTERED 
(
	[Unit1Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


