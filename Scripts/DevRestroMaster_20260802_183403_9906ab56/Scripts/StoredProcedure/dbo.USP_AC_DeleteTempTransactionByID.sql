SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_AC_DeleteTempTransactionByID] @transactionID INT
	,@username NVARCHAR(256)
AS
--declare @transactionID int=1
--,@deletedBy nvarchar(256)='sageframe'
UPDATE Ac_TempTransaction
SET IsDeleted = 1
	,DeletedBy = @username
	,DeletedOn = getdate()
WHERE TransactionID = @transactionID



GO
