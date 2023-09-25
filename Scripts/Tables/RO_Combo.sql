

CREATE TABLE [dbo].[RO_Combo](
	[ComboID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](250) NULL,
	[Description] [nvarchar](max) NULL,
	[ComboCode] [nvarchar](250) NULL,
	[ImagePath] [nvarchar](250) NULL,
	[StartDate] [datetime] NULL,
	[EndDate] [datetime] NULL,
	[CostCenterID] [int] NULL,
	[SalesPrice] [decimal](14, 4) NULL,
	[ItemsSalesCost] [decimal](14, 4) NULL,
	[IsActive] [bit] NULL CONSTRAINT [DF_RO_Combo_IsActive]  DEFAULT ((1)),
	[AddedOn] [datetime] NULL CONSTRAINT [DF_RO_Combo_AddedOn]  DEFAULT (getdate()),
	[AddedBy] [nvarchar](250) NULL,
	[UpdatedOn] [datetime] NULL,
	[UpdatedBy] [nvarchar](250) NULL,
	[IsDeleted] [bit] NULL CONSTRAINT [DF_RO_Combo_IsDeleted]  DEFAULT ((0)),
	[DeletedOn] [datetime] NULL,
	[DeletedBy] [nvarchar](250) NULL,
 CONSTRAINT [PK_RO_Combo] PRIMARY KEY CLUSTERED 
(
	[ComboID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO


