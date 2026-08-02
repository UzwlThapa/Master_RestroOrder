SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--USP_STOCKREPORTMONTHLY '2016-09-15 00:00:00.000'

CREATE PROCEDURE [dbo].[USP_STOCKREPORTRANGE]
@StardDate datetime,
@EndDate datetime
AS
BEGIN

SELECT ITName,
OPBal ,
CLBal,
StName,
cast(ExpDate as varchar(12)) as ExpDate ,
cast(PostedDate as varchar(12)) as PbDate , *
 FROM DBO.ROI_ITEMBal ib
INNER JOIN DBO.ROI_ITEMMain IM ON IB.ITId = IM.ITId
INNER JOIN DBO.ROI_Store RS ON RS.STId =  IB.STId
INNER JOIN DBO.ROI_PurchaseLotNo pl ON ib.PDId = pl.PurchaseDetailsID
where cast(PostedDate as date) between @StardDate and @EndDate
END




GO
