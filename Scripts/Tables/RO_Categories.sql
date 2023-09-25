

CREATE TABLE [dbo].[RO_Categories](
	[CategoriesID] [int] IDENTITY(1,1) NOT NULL,
	[MenuID] [int] NOT NULL,
	[CategoriesName] [varchar](128) NULL,
	[PhotoPath] [varchar](128) NULL,
 CONSTRAINT [PK_RO_Categories] PRIMARY KEY CLUSTERED 
(
	[CategoriesID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[RO_Categories]  WITH CHECK ADD  CONSTRAINT [FK_RO_Categories_RO_Menus] FOREIGN KEY([MenuID])
REFERENCES [dbo].[RO_Menus] ([MenuID])
GO

ALTER TABLE [dbo].[RO_Categories] CHECK CONSTRAINT [FK_RO_Categories_RO_Menus]
GO


