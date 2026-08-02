SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_CAKEORDERCANCEL]
@OrderMasterID int,
@CancelReason NVARCHAR(MAX)
AS
BEGIN
UPDATE RO_CakeOrderMaster
SET CancelReason=@CancelReason
,StatusId=(select Id from RO_StatusMaster where LookUpName='cancelled')
WHERE OrderMasterID=@OrderMasterID
END

GO
