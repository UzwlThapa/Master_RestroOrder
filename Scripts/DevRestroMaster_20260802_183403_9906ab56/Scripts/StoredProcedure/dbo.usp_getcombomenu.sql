SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_getcombomenu]
as
begin
select ComboID,
		Name,
		ImagePath from dbo.RO_Combo

end




GO
