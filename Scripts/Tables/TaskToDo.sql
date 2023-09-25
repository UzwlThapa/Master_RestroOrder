

CREATE TABLE [dbo].[TaskToDo](
	[TaskID] [int] IDENTITY(1,1) NOT NULL,
	[Note] [ntext] NULL,
	[Date] [date] NULL,
	[PortalId] [int] NULL,
	[ModuleId] [int] NULL,
	[CultureField] [nvarchar](100) NULL,
	[AddedOn] [date] NULL,
	[AddedBy] [nvarchar](100) NULL,
	[UpdateOn] [date] NULL,
	[UpdateBy] [nvarchar](100) NULL,
	[DeletedOn] [date] NULL,
	[Deletedby] [nvarchar](100) NULL,
	[IsActive] [bit] NULL,
	[IsDeleted] [bit] NULL,
 CONSTRAINT [PK_TaskToDo] PRIMARY KEY CLUSTERED 
(
	[TaskID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO


