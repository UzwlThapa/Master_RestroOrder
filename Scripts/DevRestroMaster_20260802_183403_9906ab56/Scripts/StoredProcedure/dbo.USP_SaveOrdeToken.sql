SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--DROP procedure [USP_SaveOrdeToken]

CREATE PROCEDURE [dbo].[USP_SaveOrdeToken]
@OrderMasterID int
,@CustomerID int
,@CustomerName nvarchar(150) = null
,@Phone nvarchar(50) = null
,@TokenNo int
,@Address nvarchar(150) = null
as 
BEGIN
IF EXISTS(select OrderMasterID from RO_OrderToken where OrderMasterID = @OrderMasterID)
BEGIN
Delete from RO_OrderToken where OrderMasterID = @OrderMasterID
END
Insert into RO_OrderToken
(
OrderMasterID
,CustomerID
,CustomerName
,Phone
,TokenNo
,AddedBy
,Address
)
values
(
@OrderMasterID
,@CustomerID
,@CustomerName
,@Phone
,@TokenNo
,getdate()
,@Address 
)
END



GO
