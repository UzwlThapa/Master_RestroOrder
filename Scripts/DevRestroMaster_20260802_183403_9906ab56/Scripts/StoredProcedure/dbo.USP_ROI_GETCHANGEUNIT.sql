SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_ROI_GETCHANGEUNIT]
@unitid INT
AS
BEGIN
select UnitDescription, FirstUnit, SecondUnit from dbo.ROI_Unit1 U
INNER JOIN ROI_Unit2 UU ON UU.FirstUnit = U.Unit1Id where FirstUnit = @unitid
END





GO
