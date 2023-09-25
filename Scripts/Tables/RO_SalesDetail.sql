

CREATE TABLE [dbo].[RO_SalesDetail](
	[salesDetailId] [int] IDENTITY(1,1) NOT NULL,
	[salesMasterId] [int] NULL,
	[ItemId] [int] NULL,
	[qty] [int] NULL,
	[rate] [decimal](8, 2) NULL,
	[Amount] [decimal](8, 2) NULL,
	[NetAmount] [decimal](8, 2) NULL,
	[CostCenterId] [int] NULL,
	[IsCombo] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[salesDetailId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO


