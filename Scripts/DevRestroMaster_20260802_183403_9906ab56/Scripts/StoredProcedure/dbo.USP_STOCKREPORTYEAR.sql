SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--USP_STOCKREPORTYEAR '2016-09-15 00:00:00.000'
--[dbo].[USP_STOCKREPORTYEAR] '2016'
CREATE PROCEDURE [dbo].[USP_STOCKREPORTYEAR]
@year varchar(10)
AS
BEGIN

SELECT ITName,
OPBal ,
CLBal,
StName,
--cast(ExpDate as varchar(12)) as ExpDate ,
--cast(PostedDate as varchar(12)) as PbDate ,
 *
 FROM DBO.ROI_ITEMBal ib
INNER JOIN DBO.ROI_ITEMMain IM ON IB.ITId = IM.ITId
INNER JOIN DBO.ROI_Store RS ON RS.STId =  IB.STId
--inner join dbo.ROI_PurchaseDetails pd on pd.PurchaseDetailsID=ib.PDId
--inner join dbo.ROI_PurchaseMain pm on pm.PurchaseMainID=pd.PurchaseDetailsID
--INNER JOIN DBO.ROI_PurchaseLotNo pl ON ib.PDId = pl.PurchaseDetailsID 

where Year(PostedDate)=@year 
END







GO
