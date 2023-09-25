

CREATE TABLE [dbo].[DailyChalanReturnedDetail](
	[returnedID] [int] IDENTITY(1,1) NOT NULL,
	[ReturnedBy] [nvarchar](256) NOT NULL,
	[ReturnedAmount] [decimal](18, 2) NOT NULL,
	[Remarks] [nvarchar](500) NOT NULL,
	[DailyChalanId] [int] NOT NULL,
 CONSTRAINT [PK_DailyChalanReturnedDetail] PRIMARY KEY CLUSTERED 
(
	[returnedID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO


