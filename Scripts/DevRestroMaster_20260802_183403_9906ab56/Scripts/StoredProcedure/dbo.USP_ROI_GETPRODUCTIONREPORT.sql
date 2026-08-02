SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_ROI_GETPRODUCTIONREPORT]
@StartDate datetime,
@EndDate datetime

AS
BEGIN

select convert(varchar(10),c.RawAssignAt) as RawAssignAt,
convert(varchar(10),c.ProductReleaseAt) ProductReleaseAt,
 * from dbo.PR_ProductionInstant c where AddedOn BETWEEN @StartDate and @EndDate
END



GO
