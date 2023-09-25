

CREATE TABLE [dbo].[DailyChalanMaster](
	[DailyChalanId] [int] IDENTITY(1,1) NOT NULL,
	[TotalAmount] [decimal](18, 2) NOT NULL,
	[AssignedBy] [nvarchar](256) NOT NULL,
	[IssuedBalance] [decimal](18, 2) NOT NULL,
	[ReturnedBalance] [decimal](18, 2) NOT NULL,
 CONSTRAINT [PK_DailyChalanMaster] PRIMARY KEY CLUSTERED 
(
	[DailyChalanId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO


