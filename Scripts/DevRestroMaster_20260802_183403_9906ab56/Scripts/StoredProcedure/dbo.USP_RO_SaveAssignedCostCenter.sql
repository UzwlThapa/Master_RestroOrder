SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_RO_SaveAssignedCostCenter]
@UserName nvarchar(500),
@CostCenterName nvarchar(500)
AS

UPDATE Users
SET AssignedCostCentre=@CostCenterName
WHERE Username=@UserName;




GO
