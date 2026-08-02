SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ROI_GetUnitByUNITID] 
@muid int
as
begin
select FUnit, SUnit from dbo.FGetUnitTB() WHERE UnitId = @muid
end







GO
