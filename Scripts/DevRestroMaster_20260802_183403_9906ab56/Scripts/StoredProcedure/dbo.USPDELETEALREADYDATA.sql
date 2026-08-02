SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USPDELETEALREADYDATA]
@ProductionInstantID INT
AS
BEGIN
DELETE FROM PR_RawUsed WHERE ProductionInstantID = @ProductionInstantID
DELETE FROM PR_ProductRelease WHERE ProductionInstantID = @ProductionInstantID
DELETE FROM PR_ProductionInstant WHERE ProductionInstantID = @ProductionInstantID

END



GO
