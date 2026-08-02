SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[usp_L_MaterialType_DeleteMaterialTypeByID]
@id int
as

delete from dbo.L_MaterialType where dbo.L_MaterialType.ID=@id



GO
