SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_ac_deleteTransactionDetailByID]
@TransactionID int
as
delete Ac_TempTransactionDetail where TransactionID=@TransactionID



GO
