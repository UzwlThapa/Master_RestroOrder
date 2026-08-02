SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[usp_L_MaterialType_SaveMaterialType]
@type nvarchar(max)
as

insert into dbo.L_MaterialType(Type) values(@type)



GO
