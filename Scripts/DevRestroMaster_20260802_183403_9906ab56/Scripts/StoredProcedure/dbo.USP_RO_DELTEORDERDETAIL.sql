SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_RO_DELTEORDERDETAIL]
@OrderMasterId INT,
@UserName nvarchar(256)
AS
BEGIN

DELETE FROM RO_Order_Detail WHERE OrderMasterId = @OrderMasterId
--update RO_Order_Detail 
--set IsArchived=1,
--ArchivedOn=GetDate(),
--ArchivedBy=@UserName
--WHERE OrderMasterId = @OrderMasterId
end





GO
