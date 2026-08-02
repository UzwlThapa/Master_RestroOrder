SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_getadjustmentDetails]
AS
BEGIN
SELECT * FROM dbo.AdjustmentDetls ad
LEFT JOIN dbo.AdjustmentMain am ON	am.AMId = ad.AMId
END	




GO
