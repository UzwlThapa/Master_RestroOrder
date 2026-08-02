SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--DRop proc [dbo].[ROI_GetUnit1]  
CREATE PROCEDURE [dbo].[ROI_GetUnit1]  
as  
begin  
select * from ROI_Unit1  where IsArchived=0
order by UnitDescription
end  




GO
