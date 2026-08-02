SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- USP_GETCOMBOBYID 16
--DROP PROCEDURE [dbo].[USP_GETCOMBOBYID]
CREATE PROCEDURE [dbo].[USP_GETCOMBOBYID]
@comboid INT
AS
BEGIN

select C.ComboID,
		c.Name,
		c.ComboCode,
		c.ImagePath,
		CONVERT(VARCHAR(10), c.StartDate, 120) as StartDatee,	
		CONVERT(VARCHAR(10), c.EndDate, 120) as EndDatee,
		
		c.SalesPrice,
		ir.SRate as ItemsSalesCost,
		cd.ItemID,
		I.ITName,
		cd.Quantity,
		cd.ItemRate,
		cd.TotalPrice
		 from dbo.RO_Combo c
INNER JOIN DBO.RO_ComboDetails CD ON CD.ComboID = C.ComboID 
INNER JOIN DBO.ROI_ITEMMain I ON I.ITId = CD.ItemID
inner join dbo.ROI_ItemRate ir on ir.ItemID = I.ITId
 where c.ComboID = @comboid

END



GO
