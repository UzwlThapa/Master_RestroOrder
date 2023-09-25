

CREATE TABLE [dbo].[tbl_CTransaction](
	[CPBalID] [int] IDENTITY(1,1) NOT NULL,
	[CID] [int] NULL,
	[IsOpening] [bit] NULL,
	[Amount] [nchar](10) NULL,
	[NCPID] [int] NULL,
	[Date] [datetime] NULL,
	[CostCenterID] [nchar](10) NULL,
	[Time] [nchar](10) NULL,
	[OCPID] [int] NULL,
 CONSTRAINT [PK_tbl_CTransaction] PRIMARY KEY CLUSTERED 
(
	[CPBalID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO


