
CREATE TABLE [dbo].[SageFrameSearchProcedure](
	[SageFrameSearchProcedureID] [int] IDENTITY(1,1) NOT NULL,
	[SageFrameSearchTitle] [nvarchar](100) NULL,
	[SageFrameSearchProcedureName] [nvarchar](256) NULL,
	[SageFrameSearchProcedureExecuteAs] [nvarchar](50) NULL,
	[IsActive] [bit] NULL CONSTRAINT [DF_SageFrameSearchProcedure_IsActive]  DEFAULT ((1)),
	[IsDeleted] [bit] NULL CONSTRAINT [DF_SageFrameSearchProcedure_IsDeleted]  DEFAULT ((0)),
	[IsModified] [bit] NULL CONSTRAINT [DF_SageFrameSearchProcedure_IsModified]  DEFAULT ((0)),
	[AddedOn] [datetime] NULL CONSTRAINT [DF_SageFrameSearchProcedure_AddedOn]  DEFAULT (getdate()),
	[UpdatedOn] [datetime] NULL CONSTRAINT [DF_SageFrameSearchProcedure_UpdatedOn]  DEFAULT (getdate()),
	[DeletedOn] [datetime] NULL,
	[PortalID] [int] NULL CONSTRAINT [DF_SageFrameSearchProcedure_PortalID]  DEFAULT ((1)),
	[AddedBy] [nvarchar](256) NULL,
	[UpdatedBy] [nvarchar](256) NULL,
	[DeletedBy] [nvarchar](256) NULL,
 CONSTRAINT [PK_SageFrameSearchProcedure] PRIMARY KEY CLUSTERED 
(
	[SageFrameSearchProcedureID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO


