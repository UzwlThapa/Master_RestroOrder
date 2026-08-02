SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--DROp PROCEDURE [dbo].[USP_GetCostCenter]
CREATE PROCEDURE [dbo].[USP_GetCostCenter]
as
begin

select CostCenterID, CostCenterName,DefaultPrinter,coDiscount, GroupId from dbo.CostCenterInfo order by CostCenterName asc
end


GO
