SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_CHECKPO_GOODRECEIVED]
@PurchaseDetailsID int
as
SELECT PDId
FROM          
RO_GoodsReceivedDetls where PDId IN
(SELECT PD.PurchaseDetailsID FROM ROI_PurchaseDetails as PD 
where PD.PurchaseDetailsID = @PurchaseDetailsID)

GO
