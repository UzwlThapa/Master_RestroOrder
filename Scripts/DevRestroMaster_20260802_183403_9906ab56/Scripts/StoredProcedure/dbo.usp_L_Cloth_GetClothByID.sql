SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[usp_L_Cloth_GetClothByID]
@id int
as

select * from dbo.L_Cloth where dbo.L_Cloth.ID=@id



GO
