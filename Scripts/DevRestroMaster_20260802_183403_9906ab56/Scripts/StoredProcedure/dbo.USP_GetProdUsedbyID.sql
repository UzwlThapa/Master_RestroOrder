SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_GetProdUsedbyID]
@ProductionID int
AS
BEGIN
select * from PR_RawUsed r
inner join ROI_ITEMMain IM ON IM.ITID = r.ItemID
INNER JOIN ROI_Store m ON m.STId = r.StoreID
 where ProductionInstantID = @ProductionID

 end



GO
