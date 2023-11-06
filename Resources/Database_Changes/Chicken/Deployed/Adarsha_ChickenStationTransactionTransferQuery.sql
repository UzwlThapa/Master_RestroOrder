DECLARE @MainAc int
DECLARE @AltAcc int
SELECT @MainAc = FinancialAcID from Ac_FinancialAc where [Name] = 'Rohit Gamal'
SELECT @AltAcc = FinancialAcID from Ac_FinancialAc where [Name] = 'Rohit'

UPDATE Ac_TransactionDetail SET FinancialAcID = @MainAc WHERE FinancialAcID = @AltAcc;
UPDATE Ac_TempTransactionDetail SET FinancialAcID = @MainAc WHERE FinancialAcID = @AltAcc;
UPDATE Ac_FinancialAc SET IsArchived = 1 WHERE FinancialAcID = @AltAcc;

UPDATE Ac_FinancialAc SET Name = 'Nirmal Chef  A/C' where FinancialAcID = 3742



SELECT @MainAc = FinancialAcID from Ac_FinancialAc where [Name] = 'Nirmal Chef  A/C';
SELECT @AltAcc = FinancialAcID from Ac_FinancialAc where [Name] = 'Nirmal Chef';

UPDATE Ac_TransactionDetail SET FinancialAcID = @MainAc WHERE FinancialAcID = @AltAcc;
UPDATE Ac_TempTransactionDetail SET FinancialAcID = @MainAc WHERE FinancialAcID = @AltAcc;
UPDATE Ac_FinancialAc SET IsArchived = 1 WHERE FinancialAcID = @AltAcc;




SELECT @MainAc = FinancialAcID from Ac_FinancialAc where [Name] = 'DilipKutu A/C';
SELECT @AltAcc = FinancialAcID from Ac_FinancialAc where [Name] = 'Dilip';

UPDATE Ac_TransactionDetail SET FinancialAcID = @MainAc WHERE FinancialAcID = @AltAcc;
UPDATE Ac_TempTransactionDetail SET FinancialAcID = @MainAc WHERE FinancialAcID = @AltAcc;
UPDATE Ac_FinancialAc SET IsArchived = 1 WHERE FinancialAcID = @AltAcc;


UPDATE Ac_FinancialAc SET IsArchived = 1 WHERE FinancialAcID = 3715;
