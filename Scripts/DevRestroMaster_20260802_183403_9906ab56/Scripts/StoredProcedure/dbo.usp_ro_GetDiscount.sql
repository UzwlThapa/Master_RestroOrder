SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--usp_ro_GetDiscount 49
CREATE PROCEDURE [dbo].[usp_ro_GetDiscount] @salesMasterId INT
AS
SELECT fd.*
from ro_flatandPerDiscount fd 
WHERE fd.salesMasterId = @salesMasterId


GO
