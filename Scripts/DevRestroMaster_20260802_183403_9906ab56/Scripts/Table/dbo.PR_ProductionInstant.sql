SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PR_ProductionInstant](
	[ProductionInstantID] [int] IDENTITY(1,1) NOT NULL,
	[RawAssignAt] [datetime] NULL,
	[ProductReleaseAt] [datetime] NULL,
	[MainChef] [nvarchar](250) NULL,
	[State] [int] NULL,
	[AddedBy] [nvarchar](250) NULL,
	[AddedOn] [datetime] NULL,
	[ProductCompletedBy] [nvarchar](250) NULL,
 CONSTRAINT [PK_PR_ProductionInstant] PRIMARY KEY CLUSTERED 
(
	[ProductionInstantID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
