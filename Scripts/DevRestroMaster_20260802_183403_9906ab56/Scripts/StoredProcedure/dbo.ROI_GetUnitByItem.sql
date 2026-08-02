SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ROI_GetUnitByItem] 
@itid int
as
begin
select MUnitId from dbo.ROI_ItemDetails WHERE ITId = @itid
end







GO
