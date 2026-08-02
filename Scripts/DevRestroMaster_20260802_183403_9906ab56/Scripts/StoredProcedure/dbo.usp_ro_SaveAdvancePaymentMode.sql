SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--DROP Procedure usp_ro_SaveAdvancePaymentMode 
CREATE PROCEDURE [dbo].[usp_ro_SaveAdvancePaymentMode] 
@RoomBookDetailsId int
,@VoucherNo nvarchar(256)
,@PaymentModeID int
,@ProviderID int
,@TransactionNo nvarchar(256)
,@TransactionId int 
,@PayAmount decimal(18,2)
AS
BEGIN
INSERT INTO RO_AdvancePaymentMode
(
RoomBookDetailsId
,VoucherNo
,PaymentModeID
,ProviderID
,TransactionNo
,TransactionID
,PayAmount
,SettlementAmount
)
Values 

(
@RoomBookDetailsId
,@VoucherNo
,@PaymentModeID
,@ProviderID
,@TransactionNo
,@TransactionId
,@PayAmount
,0
)
END

GO
