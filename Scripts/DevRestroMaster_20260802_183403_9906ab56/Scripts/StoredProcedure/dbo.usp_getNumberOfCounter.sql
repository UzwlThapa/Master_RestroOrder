SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--[dbo].[usp_getNumberOfCounter] 1
CREATE PROCEDURE [dbo].[usp_getNumberOfCounter]
@ccid int
as
select NumberOfCounter from dbo.CostCenterInfo where CostCenterId=@ccid




GO
