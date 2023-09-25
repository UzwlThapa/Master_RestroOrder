

CREATE TABLE [dbo].[tbl_cus_credit](
	[CusCreditID] [int] IDENTITY(1,1) NOT NULL,
	[MembershipID] [int] NULL,
	[RemainingBalance] [nvarchar](256) NULL,
	[Date] [nvarchar](256) NULL,
 CONSTRAINT [PK_tbl_cus_credit] PRIMARY KEY CLUSTERED 
(
	[CusCreditID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO


