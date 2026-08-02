SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ROI_UNIT2DELETE]
@UnitID2 INT
as
begin
--update ROI_Unit1 set IsArchived=1, ArchivedOn=GETDATE() where Unit1Id=@UnitID2
update ROI_Unit2 set isarchived=1, ArchivedOn=GETDATE() where Unit2ID=@UnitID2
		SELECT 200
--delete from dbo.ROI_Unit3 where UnitId=@UnitID2

end






GO
