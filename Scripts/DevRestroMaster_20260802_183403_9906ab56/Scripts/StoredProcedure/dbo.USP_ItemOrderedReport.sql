SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_ItemOrderedReport]

@startDate Datetime,
@endDate Datetime

AS
BEGIN
--declare @startDate DATETIME='2018-1-26 0:0',@endDate DATETIME='2018-02-27 23:59'
select 
CCI.CostCenterName,
IM.ITName,
SUM(OD.Quantity) as QTY
FROM RO_Order_Detail OD 
INNER JOIN ROI_ITEMMain Im ON IM.ITId = OD.ROI_ItemId
left join CostCenterInfo CCI on CCI.CostCenterId = OD.CostCenterId 
where od.IsCancelled=0 and (OD.Date BETWEEN  DATEADD(hour,4, @startDate)
			AND DATEADD(hour,4, @endDate))
GROUP BY CCI.CostCenterName, IM.ITName
END

GO
