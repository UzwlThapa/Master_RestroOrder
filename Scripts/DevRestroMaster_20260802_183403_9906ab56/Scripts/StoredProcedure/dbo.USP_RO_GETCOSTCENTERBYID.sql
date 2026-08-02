SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--EXEC USP_RO_GETCOSTCENTERBYID 1
CREATE PROCEDURE [dbo].[USP_RO_GETCOSTCENTERBYID]

@CostCenterId int

AS

BEGIN
	SELECT CostCenterId,CostCenterName,CostCenterAddedBy,CostCenterAddedDate,DefaultPrinter,coDiscount,NumberOfCounter,StoreId,ISNULL(CCI.GroupId,0) [GroupId],storeid store, CG.GroupName FROM dbo.CostCenterInfo CCI
	LEFT JOIN RO_CostCenterGroup CG ON CCI.GroupId=CG.GroupId
	where CCi.CostCenterId = @CostCenterId
END	




GO
