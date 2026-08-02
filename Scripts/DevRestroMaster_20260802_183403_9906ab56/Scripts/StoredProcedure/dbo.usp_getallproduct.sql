SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_getallproduct]
AS
BEGIN
select convert(varchar(10),
c.RawAssignAt, 10) as RawAssignAt,
convert(varchar(10),c.ProductReleaseAt, 10) ProductReleaseAt,
 * from dbo.PR_ProductionInstant c
END



GO
