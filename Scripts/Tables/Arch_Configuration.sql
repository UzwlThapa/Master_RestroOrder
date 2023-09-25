
CREATE TABLE [dbo].[Arch_Configuration](
	[ConfigID] [int] IDENTITY(1,1) NOT NULL,
	[ArchTable] [nvarchar](120) NULL,
	[ThresholdFreq] [int] NULL,
	[CrosscheckFreq] [int] NULL,
	[keyColumn] [nvarchar](50) NULL,
	[is_active] [bit] NULL,
 CONSTRAINT [PK_Arch_Configuration] PRIMARY KEY CLUSTERED 
(
	[ConfigID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO


