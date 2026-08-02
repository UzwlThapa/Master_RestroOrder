SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DeletePointSchemebyId]
@PSchemeId int
as begin 
Delete RO_PointScheme where PSchemeId=@PSchemeId
end



GO
