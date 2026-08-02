SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[usp_L_Cloth_DeleteClothByID]
@id int
as

delete from dbo.L_Cloth where dbo.L_Cloth.ID=@id



GO
