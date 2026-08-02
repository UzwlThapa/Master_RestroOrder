SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_Ac_GetAcOpeningBalanceById]
@Id INT
AS
BEGIN
	SELECT op.AcOpeningId,op.IsLoyalty,op.MemberShipId,op.TranId,op.TranDate,op.OpeningAmt,op.IsDebit,op.AddedOn,op.AddedBy,op.UpdatedOn,ISNULL(op.IsArchived,0) [IsArchived],fc.Name [AcName] FROM [dbo].[Ac_OpeningBalanceDetail] op
	INNER JOIN Ac_TransactionDetail td On td.TransactionID=op.TranId
	INNER JOIN Ac_FinancialAc fc on td.FinancialAcID = fc.FinancialAcID
	where op.[IsArchived] IS NULL and op.AcOpeningId=@Id

END

GO
