ALTER TABLE dbo.Ac_Transaction
ADD SalesMasterId INT NULL

ALTER TABLE dbo.Ac_TempTransaction
ADD SalesMasterId INT NULL


ALTER TABLE dbo.Ac_Transaction ADD BillDate DATETIME NULL;
ALTER TABLE dbo.Ac_TempTransaction ADD BillDate DATETIME NULL;
