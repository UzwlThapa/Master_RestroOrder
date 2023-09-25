

CREATE TABLE [dbo].[ro_flatandPerDiscount](
	[pfdId] [int] IDENTITY(1,1) NOT NULL,
	[orderMasterId] [int] NULL,
	[kotdis] [varchar](128) NULL,
	[bardis] [varchar](128) NULL,
	[isflatdis] [bit] NULL,
	[isLoyalty] [bit] NULL,
	[loyaltydis] [varchar](128) NULL,
PRIMARY KEY CLUSTERED 
(
	[pfdId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


