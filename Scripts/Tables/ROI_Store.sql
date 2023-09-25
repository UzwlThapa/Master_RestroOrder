

CREATE TABLE [dbo].[ROI_Store](
	[STId] [int] IDENTITY(1,1) NOT NULL,
	[StName] [varchar](50) NOT NULL,
	[PSTId] [int] NOT NULL,
	[Hirerchy] [varchar](250) NULL,
	[IsActive] [bit] NOT NULL CONSTRAINT [DF_ROI_Store_IsActive]  DEFAULT ((1)),
	[IsDeleted] [bit] NOT NULL CONSTRAINT [DF_ROI_Store_IsDeleted]  DEFAULT ((0)),
	[AddedBy] [nvarchar](256) NULL,
	[AddedOn] [datetime] NULL CONSTRAINT [DF_ROI_Store_AddedOn]  DEFAULT (getdate()),
	[DeletedBy] [nvarchar](256) NULL,
	[DeletedOn] [datetime] NULL,
	[ModifiedBy] [nvarchar](256) NULL,
	[ModifiedOn] [datetime] NULL,
 CONSTRAINT [PK_Store] PRIMARY KEY CLUSTERED 
(
	[STId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


