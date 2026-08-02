SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_SaveRecquistionForVendor]
@RecqId INT,
@RecqDetailId INT,
@VendorId INT,
@AddedBy nvarchar(250)
AS
BEGIN
Update Req_Recquistion set StatusId=2 where RecqId=@RecqId;
Update Req_RecquistionDetails set StatusId=2 where RecqId=@RecqId;

Insert into RO_VendorPurchase(
RecqId,
RecqDetailId,
VendorId,
AddedOn,
AddedBy
)
VALUES
(
@RecqId,
@RecqDetailId,
@VendorId,
getdate(),
@AddedBy
)
END


GO
