SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RO_SalesDetail](
	[salesDetailId] [int] IDENTITY(1,1) NOT NULL,
	[salesMasterId] [int] NULL,
	[ItemId] [int] NULL,
	[qty] [float] NULL,
	[rate] [decimal](18, 2) NULL,
	[Amount] [decimal](18, 2) NULL,
	[NetAmount] [decimal](18, 2) NULL,
	[CostCenterId] [int] NULL,
	[IsCombo] [bit] NULL,
	[HsCode] [nvarchar](250) NULL,
PRIMARY KEY CLUSTERED 
(
	[salesDetailId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE TRIGGER [dbo].[RO_SalesDetail_Delete] ON [dbo].[RO_SalesDetail] 
FOR DELETE, UPDATE
AS
ROLLBACK TRANSACTION
	RAISERROR ('Update and Deletions not allowed from this table', 16, 1)

GO
ALTER TABLE [dbo].[RO_SalesDetail] ENABLE TRIGGER [RO_SalesDetail_Delete]
GO
