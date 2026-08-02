SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_ROI_FGETUNITB]    
AS    
BEGIN    
select Unit1Id as UnitId,Unit1Id FUnit, Unit1Id SUnit, 1 as Conversion, UnitDescription Particulars,Symbol from ROI_Unit1  
where IsArchived=0
--select * from fgetunitTB()    
END 



GO
