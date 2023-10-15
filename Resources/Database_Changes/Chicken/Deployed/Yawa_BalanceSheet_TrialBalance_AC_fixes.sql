DECLARE @AccEntryTypeId INT;
SELECT @AccEntryTypeId = Id
FROM   Ac_EntryType
WHERE  AccountEntryType = 'Balance Sheet';


DECLARE @TransactionNodeId INT;
SELECT @TransactionNodeId = FinancialSysID
FROM   Ac_FinancialSys
WHERE  Name = 'Transaction Node';
DECLARE @GroupNodeId INT;
SELECT @GroupNodeId = FinancialSysID
FROM   Ac_FinancialSys
WHERE  Name = 'Group Node';

DECLARE @AssetId INT;
SELECT @AssetId = FinancialAcID
FROM   Ac_FinancialAc
WHERE  Name = 'ASSETS';


--- VAT RECEIVABLE
IF NOT EXISTS ( SELECT 1
                FROM   Ac_FinancialAc
                WHERE  Name = 'VAT RECEIVABLE' )
    BEGIN
        INSERT INTO Ac_FinancialAc ( Name ,
                                     PFinancialAcID ,
                                     FinancialSysID ,
                                     AddedBy ,
                                     AddedOn ,
                                     IsArchived ,
                                     IsDebit ,
                                     IsShownInBalanceSheet ,
                                     AccEntryType )
        VALUES ( 'VAT RECEIVABLE', @AssetId, @GroupNodeId, 'danfe', GETDATE (), 1, 0, 1, @AccEntryTypeId );
    END;
ELSE
    BEGIN
        UPDATE Ac_FinancialAc
        SET    FinancialSysID = @GroupNodeId ,
               PFinancialAcID = @AssetId ,
               IsDebit = 1 ,
               IsShownInBalanceSheet = 1 ,
               AccEntryType = @AccEntryTypeId
        WHERE  Name = 'VAT RECEIVABLE';
    END;


DECLARE @VatReceivableId INT;
SELECT @VatReceivableId = FinancialAcID
FROM   Ac_FinancialAc
WHERE  Name = 'VAT RECEIVABLE';


--- VAT RECEIVABLE A/C
IF NOT EXISTS ( SELECT 1
                FROM   Ac_FinancialAc
                WHERE  Name = 'VAT RECEIVABLE A/C' )
    BEGIN
        INSERT INTO Ac_FinancialAc ( Name ,
                                     PFinancialAcID ,
                                     FinancialSysID ,
                                     AddedBy ,
                                     AddedOn ,
                                     IsArchived ,
                                     IsDebit ,
                                     AccEntryType )
        VALUES ( 'VAT RECEIVABLE A/C', @AssetId, @TransactionNodeId, 'danfe', GETDATE (), 0, 1, @AccEntryTypeId );
    END;
ELSE
    BEGIN
        UPDATE Ac_FinancialAc
        SET    FinancialSysID = @TransactionNodeId ,
               PFinancialAcID = @AssetId ,
               IsDebit = 1 ,
               AccEntryType = @AccEntryTypeId
        WHERE  Name = 'VAT RECEIVABLE A/C';
    END;

