SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_DELETEPurchaseMainID]
@PurchaseMainID int
as
Delete ROI_PurchaseDetails where PurchaseMainID=@PurchaseMainID



GO
