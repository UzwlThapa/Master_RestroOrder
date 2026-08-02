SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[USP_GET_MEMBER_EXTRABILLING]
@eid int
AS
BEGIN

SELECT * 
FROM tbl_ExtraBillingMaster
FULL OUTER JOIN tbl_ExtraBillingDetails
ON tbl_ExtraBillingMaster.ExtraBillingID=tbl_ExtraBillingDetails.BillingID
Where ExtraBillingID = @eid

END




GO
