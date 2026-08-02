SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_ro_getdiscountfromcostcenter]
AS
BEGIN
	--SELECT CostCenterId,coDiscount,CostCenterName FROM dbo.CostCenterInfo
	SELECT CostCenterID,CostCenterName,coDiscount FROM dbo.CostCenterInfo
END




GO
