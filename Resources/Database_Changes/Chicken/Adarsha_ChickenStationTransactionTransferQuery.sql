DECLARE @MainAc int
DECLARE @AltAcc int
SELECT @MainAc = FinancialAcID from Ac_FinancialAc where [Name] = 'Rohit Gamal'
SELECT @AltAcc = FinancialAcID from Ac_FinancialAc where [Name] = 'Rohit'

UPDATE Ac_TransactionDetail SET FinancialAcID = @MainAc WHERE FinancialAcID = @AltAcc;
UPDATE Ac_TempTransactionDetail SET FinancialAcID = @MainAc WHERE FinancialAcID = @AltAcc;