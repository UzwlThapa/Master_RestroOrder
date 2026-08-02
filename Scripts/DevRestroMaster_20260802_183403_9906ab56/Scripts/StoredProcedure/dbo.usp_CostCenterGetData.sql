SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--DROP PROCEDURE [dbo].[usp_CostCenterGetData]
CREATE PROCEDURE [dbo].[usp_CostCenterGetData]
AS
SELECT cci.*,st.StName,cg.GroupName FROM dbo.CostCenterInfo cci
left join ROI_Store  st on st.STId=cci.StoreId 
LEFT JOIN RO_CostCenterGroup cg on cci.GroupId=cg.groupid-- order by cci.CostCenterName
 order by  cci.CostCenterId




GO
