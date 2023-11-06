DECLARE @AccEntryTypeId INT;
SELECT @AccEntryTypeId = Id
FROM   Ac_EntryType
WHERE  AccountEntryType = 'Profit & Loss A/C';

DECLARE @TransactionNodeId INT;
SELECT @TransactionNodeId = FinancialSysID
FROM   Ac_FinancialSys
WHERE  Name = 'Transaction Node';
DECLARE @GroupNodeId INT;
SELECT @GroupNodeId = FinancialSysID
FROM   Ac_FinancialSys
WHERE  Name = 'Group Node';

/* 
	 -- EXPENSES 
 */

DECLARE @ExpensesId INT;
SELECT @ExpensesId = FinancialAcID
FROM   Ac_FinancialAc
WHERE  Name = 'EXPENSES';

--- add DIRECT EXPENSES A/C
IF NOT EXISTS ( SELECT 1
                FROM   Ac_FinancialAc
                WHERE  Name = 'DIRECT EXPENSES' )
    BEGIN
        INSERT INTO Ac_FinancialAc ( Name ,
                                     PFinancialAcID ,
                                     FinancialSysID ,
                                     AddedBy ,
                                     AddedOn ,
                                     IsArchived ,
                                     IsDebit ,
                                     AccEntryType )
        VALUES ( 'DIRECT EXPENSES', @ExpensesId, @GroupNodeId, 'danfe', GETDATE (), 0, 1, @AccEntryTypeId );
    END;
ELSE
    BEGIN
        UPDATE Ac_FinancialAc
        SET    FinancialSysID = @GroupNodeId ,
               PFinancialAcID = @ExpensesId ,
               IsDebit = 1 ,
               AccEntryType = @AccEntryTypeId
        WHERE  Name = 'DIRECT EXPENSES';
    END;

/* 
	 -- DIRECT EXPENSES 
 */
DECLARE @DirectExpensesId INT;
SELECT @DirectExpensesId = FinancialAcID
FROM   Ac_FinancialAc
WHERE  Name = 'DIRECT EXPENSES';

--- add BAR PURCHASE A/C
IF NOT EXISTS ( SELECT 1
                FROM   Ac_FinancialAc
                WHERE  Name = 'BAR PURCHASE A/C' )
    BEGIN
        INSERT INTO Ac_FinancialAc ( Name ,
                                     PFinancialAcID ,
                                     FinancialSysID ,
                                     AddedBy ,
                                     AddedOn ,
                                     IsArchived ,
                                     IsDebit ,
                                     AccEntryType )
        VALUES ( 'BAR PURCHASE A/C', @DirectExpensesId, @TransactionNodeId, 'danfe', GETDATE (), 0, 1, @AccEntryTypeId );
    END;
ELSE
    BEGIN
        UPDATE Ac_FinancialAc
        SET    FinancialSysID = @TransactionNodeId ,
               PFinancialAcID = @DirectExpensesId ,
               IsDebit = 1 ,
               AccEntryType = @AccEntryTypeId
        WHERE  Name = 'BAR PURCHASE A/C';
    END;

--- add FOOD PURCHASE A/C
IF NOT EXISTS ( SELECT 1
                FROM   Ac_FinancialAc
                WHERE  Name = 'FOOD PURCHASE A/C' )
    BEGIN
        INSERT INTO Ac_FinancialAc ( Name ,
                                     PFinancialAcID ,
                                     FinancialSysID ,
                                     AddedBy ,
                                     AddedOn ,
                                     IsArchived ,
                                     IsDebit ,
                                     AccEntryType )
        VALUES ( 'FOOD PURCHASE A/C', @DirectExpensesId, @TransactionNodeId, 'danfe', GETDATE (), 0, 1, @AccEntryTypeId );
    END;
ELSE
    BEGIN
        UPDATE Ac_FinancialAc
        SET    FinancialSysID = @TransactionNodeId ,
               PFinancialAcID = @DirectExpensesId ,
               IsDebit = 1 ,
               AccEntryType = @AccEntryTypeId
        WHERE  Name = 'FOOD PURCHASE A/C';
    END;

--- add REGULAR PURCHASE A/C
IF NOT EXISTS ( SELECT 1
                FROM   Ac_FinancialAc
                WHERE  Name = 'REGULAR PURCHASE A/C' )
    BEGIN
        INSERT INTO Ac_FinancialAc ( Name ,
                                     PFinancialAcID ,
                                     FinancialSysID ,
                                     AddedBy ,
                                     AddedOn ,
                                     IsArchived ,
                                     IsDebit ,
                                     AccEntryType )
        VALUES ( 'REGULAR PURCHASE A/C', @DirectExpensesId, @GroupNodeId, 'danfe', GETDATE (), 0, 1, @AccEntryTypeId );
    END;
ELSE
    BEGIN
        UPDATE Ac_FinancialAc
        SET    FinancialSysID = @TransactionNodeId ,
               PFinancialAcID = @DirectExpensesId ,
               IsDebit = 1 ,
               AccEntryType = @AccEntryTypeId
        WHERE  Name = 'REGULAR PURCHASE A/C';
    END;


/* 
	 -- INDIRECT EXPENSES 
 */
DECLARE @inDirectExpensesId INT;
SELECT @inDirectExpensesId = FinancialAcID
FROM   Ac_FinancialAc
WHERE  Name = 'INDIRECT EXPENSES';

--- add Jaar water
IF NOT EXISTS ( SELECT 1
                FROM   Ac_FinancialAc
                WHERE  Name = 'JAAR WATER' )
    BEGIN
        INSERT INTO Ac_FinancialAc ( Name ,
                                     PFinancialAcID ,
                                     FinancialSysID ,
                                     AddedBy ,
                                     AddedOn ,
                                     IsArchived ,
                                     IsDebit ,
                                     AccEntryType )
        VALUES ( 'JAAR WATER', @inDirectExpensesId, @TransactionNodeId, 'danfe', GETDATE (), 0, 1, @AccEntryTypeId );
    END;
ELSE
    BEGIN
        UPDATE Ac_FinancialAc
        SET    FinancialSysID = @TransactionNodeId ,
               PFinancialAcID = @inDirectExpensesId ,
               IsDebit = 1 ,
               AccEntryType = @AccEntryTypeId
        WHERE  Name = 'JAAR WATER';
    END;

-- add pop up
IF NOT EXISTS ( SELECT 1
                FROM   Ac_FinancialAc
                WHERE  Name = 'pop up' )
    BEGIN
        INSERT INTO Ac_FinancialAc ( Name ,
                                     PFinancialAcID ,
                                     FinancialSysID ,
                                     AddedBy ,
                                     AddedOn ,
                                     IsArchived ,
                                     IsDebit ,
                                     AccEntryType )
        VALUES ( 'pop up', @inDirectExpensesId, @TransactionNodeId, 'danfe', GETDATE (), 0, 1, @AccEntryTypeId );
    END;
ELSE
    BEGIN
        UPDATE Ac_FinancialAc
        SET    FinancialSysID = @TransactionNodeId ,
               PFinancialAcID = @inDirectExpensesId ,
               IsDebit = 1 ,
               AccEntryType = @AccEntryTypeId
        WHERE  Name = 'pop up';
    END;

-- add Office Expenses
IF NOT EXISTS ( SELECT 1
                FROM   Ac_FinancialAc
                WHERE  Name = 'Office Expenses' )
    BEGIN
        INSERT INTO Ac_FinancialAc ( Name ,
                                     PFinancialAcID ,
                                     FinancialSysID ,
                                     AddedBy ,
                                     AddedOn ,
                                     IsArchived ,
                                     IsDebit ,
                                     AccEntryType )
        VALUES ( 'Office Expenses', @inDirectExpensesId, @TransactionNodeId, 'danfe', GETDATE (), 0, 1, @AccEntryTypeId );
    END;
ELSE
    BEGIN
        UPDATE Ac_FinancialAc
        SET    FinancialSysID = @TransactionNodeId ,
               PFinancialAcID = @inDirectExpensesId ,
               IsDebit = 1 ,
               AccEntryType = @AccEntryTypeId
        WHERE  Name = 'Office Expenses';
    END;

-- add Fruit Shop
IF NOT EXISTS ( SELECT 1
                FROM   Ac_FinancialAc
                WHERE  Name = 'Fruit Shop' )
    BEGIN
        INSERT INTO Ac_FinancialAc ( Name ,
                                     PFinancialAcID ,
                                     FinancialSysID ,
                                     AddedBy ,
                                     AddedOn ,
                                     IsArchived ,
                                     IsDebit ,
                                     AccEntryType )
        VALUES ( 'Fruit Shop', @inDirectExpensesId, @TransactionNodeId, 'danfe', GETDATE (), 0, 1, @AccEntryTypeId );
    END;
ELSE
    BEGIN
        UPDATE Ac_FinancialAc
        SET    FinancialSysID = @TransactionNodeId ,
               PFinancialAcID = @inDirectExpensesId ,
               IsDebit = 1 ,
               AccEntryType = @AccEntryTypeId
        WHERE  Name = 'Fruit Shop';
    END;

-- add  Staff Fooding
IF NOT EXISTS ( SELECT 1
                FROM   Ac_FinancialAc
                WHERE  Name = 'Staff Fooding' )
    BEGIN
        INSERT INTO Ac_FinancialAc ( Name ,
                                     PFinancialAcID ,
                                     FinancialSysID ,
                                     AddedBy ,
                                     AddedOn ,
                                     IsArchived ,
                                     IsDebit ,
                                     AccEntryType )
        VALUES ( 'Staff Fooding', @inDirectExpensesId, @TransactionNodeId, 'danfe', GETDATE (), 0, 1, @AccEntryTypeId );
    END;
ELSE
    BEGIN
        UPDATE Ac_FinancialAc
        SET    FinancialSysID = @TransactionNodeId ,
               PFinancialAcID = @inDirectExpensesId ,
               IsDebit = 1 ,
               AccEntryType = @AccEntryTypeId
        WHERE  Name = 'Staff Fooding';
    END;


/* 
	 -- EXPENSES 
	 -- SALARY EXPENSES
 */

--- add DIRECT EXPENSES
IF NOT EXISTS ( SELECT 1
                FROM   Ac_FinancialAc
                WHERE  Name = 'SALARY EXPENSES' )
    BEGIN
        INSERT INTO Ac_FinancialAc ( Name ,
                                     PFinancialAcID ,
                                     FinancialSysID ,
                                     AddedBy ,
                                     AddedOn ,
                                     IsArchived ,
                                     IsDebit ,
                                     AccEntryType )
        VALUES ( 'SALARY EXPENSES', @ExpensesId, @GroupNodeId, 'danfe', GETDATE (), 0, 1, @AccEntryTypeId );
    END;
ELSE
    BEGIN
        UPDATE Ac_FinancialAc
        SET    FinancialSysID = @GroupNodeId ,
               PFinancialAcID = @ExpensesId ,
               IsDebit = 1 ,
               AccEntryType = @AccEntryTypeId
        WHERE  Name = 'SALARY EXPENSES';
    END;

DECLARE @SalaryExpensesId INT;
SELECT @SalaryExpensesId = FinancialAcID
FROM   Ac_FinancialAc
WHERE  Name = 'SALARY EXPENSES';

--- add Salary A/C
IF NOT EXISTS ( SELECT 1
                FROM   Ac_FinancialAc
                WHERE  Name = 'Salary A/C' )
    BEGIN
        INSERT INTO Ac_FinancialAc ( Name ,
                                     PFinancialAcID ,
                                     FinancialSysID ,
                                     AddedBy ,
                                     AddedOn ,
                                     IsArchived ,
                                     IsDebit ,
                                     AccEntryType )
        VALUES ( 'Salary A/C', @SalaryExpensesId, @TransactionNodeId, 'danfe', GETDATE (), 0, 1, @AccEntryTypeId );
    END;
ELSE
    BEGIN
        UPDATE Ac_FinancialAc
        SET    FinancialSysID = @TransactionNodeId ,
               PFinancialAcID = @SalaryExpensesId ,
               IsDebit = 1 ,
               AccEntryType = @AccEntryTypeId
        WHERE  Name = 'Salary A/C';
    END;



/* 
	 -- EXPENSES 
	 -- TOTAL DISCOUNT
 */

IF NOT EXISTS ( SELECT 1
                FROM   Ac_FinancialAc
                WHERE  Name = 'TOTAL DISCOUNT' )
    BEGIN
        INSERT INTO Ac_FinancialAc ( Name ,
                                     PFinancialAcID ,
                                     FinancialSysID ,
                                     AddedBy ,
                                     AddedOn ,
                                     IsArchived ,
                                     IsDebit ,
                                     AccEntryType )
        VALUES ( 'TOTAL DISCOUNT', @ExpensesId, @GroupNodeId, 'danfe', GETDATE (), 0, 1, @AccEntryTypeId );
    END;
ELSE
    BEGIN
        UPDATE Ac_FinancialAc
        SET    FinancialSysID = @GroupNodeId ,
               PFinancialAcID = @ExpensesId ,
               IsDebit = 1 ,
               AccEntryType = @AccEntryTypeId
        WHERE  Name = 'TOTAL DISCOUNT';
    END;

DECLARE @TotalDiscountId INT;
SELECT @TotalDiscountId = FinancialAcID
FROM   Ac_FinancialAc
WHERE  Name = 'TOTAL DISCOUNT';

--- add SALES DISCOUNT A/C
IF NOT EXISTS ( SELECT 1
                FROM   Ac_FinancialAc
                WHERE  Name = 'SALES DISCOUNT A/C' )
    BEGIN
        INSERT INTO Ac_FinancialAc ( Name ,
                                     PFinancialAcID ,
                                     FinancialSysID ,
                                     AddedBy ,
                                     AddedOn ,
                                     IsArchived ,
                                     IsDebit ,
                                     AccEntryType )
        VALUES ( 'SALES DISCOUNT A/C', @TotalDiscountId, @TransactionNodeId, 'danfe', GETDATE (), 0, 1, @AccEntryTypeId );
    END;
ELSE
    BEGIN
        UPDATE Ac_FinancialAc
        SET    FinancialSysID = @TransactionNodeId ,
               PFinancialAcID = @TotalDiscountId ,
               IsDebit = 1 ,
               AccEntryType = @AccEntryTypeId
        WHERE  Name = 'SALES DISCOUNT A/C';
    END;


--- add SURPLUS/DEFLICT A/C
IF NOT EXISTS ( SELECT 1
                FROM   Ac_FinancialAc
                WHERE  Name = 'SURPLUS/DEFLICT A/C' )
    BEGIN
        INSERT INTO Ac_FinancialAc ( Name ,
                                     PFinancialAcID ,
                                     FinancialSysID ,
                                     AddedBy ,
                                     AddedOn ,
                                     IsArchived ,
                                     IsDebit ,
                                     AccEntryType )
        VALUES ( 'SURPLUS/DEFLICT A/C', @TotalDiscountId, @TransactionNodeId, 'danfe', GETDATE (), 0, 1 ,
                 @AccEntryTypeId );
    END;
ELSE
    BEGIN
        UPDATE Ac_FinancialAc
        SET    FinancialSysID = @TransactionNodeId ,
               PFinancialAcID = @TotalDiscountId ,
               IsDebit = 1 ,
               AccEntryType = @AccEntryTypeId
        WHERE  Name = 'SURPLUS/DEFLICT A/C';
    END;



/* 
	 -- INCOME  
 */
DECLARE @salesAcId INT;
SELECT @salesAcId = FinancialAcID
FROM   Ac_FinancialAc
WHERE  Name = 'SALES';


--- add BAR SALES A/C
IF NOT EXISTS ( SELECT 1
                FROM   Ac_FinancialAc
                WHERE  Name = 'BAR SALES A/C' )
    BEGIN
        INSERT INTO Ac_FinancialAc ( Name ,
                                     PFinancialAcID ,
                                     FinancialSysID ,
                                     AddedBy ,
                                     AddedOn ,
                                     IsArchived ,
                                     IsDebit ,
                                     AccEntryType )
        VALUES ( 'BAR SALES A/C', @salesAcId, @GroupNodeId, 'danfe', GETDATE (), 0, 0, @AccEntryTypeId );
    END;
ELSE
    BEGIN
        UPDATE Ac_FinancialAc
        SET    FinancialSysID = @GroupNodeId ,
               PFinancialAcID = @salesAcId ,
               IsDebit = 0 ,
               AccEntryType = @AccEntryTypeId
        WHERE  Name = 'BAR SALES A/C';
    END;

--- add FOOD SALES A/C
IF NOT EXISTS ( SELECT 1
                FROM   Ac_FinancialAc
                WHERE  Name = 'FOOD SALES A/C' )
    BEGIN
        INSERT INTO Ac_FinancialAc ( Name ,
                                     PFinancialAcID ,
                                     FinancialSysID ,
                                     AddedBy ,
                                     AddedOn ,
                                     IsArchived ,
                                     IsDebit ,
                                     AccEntryType )
        VALUES ( 'FOOD SALES A/C', @salesAcId, @TransactionNodeId, 'danfe', GETDATE (), 0, 0, @AccEntryTypeId );
    END;
ELSE
    BEGIN
        UPDATE Ac_FinancialAc
        SET    FinancialSysID = @TransactionNodeId ,
               PFinancialAcID = @salesAcId ,
               IsDebit = 0 ,
               AccEntryType = @AccEntryTypeId
        WHERE  Name = 'FOOD SALES A/C';
    END;

--- add OTHER SALES A/C
IF NOT EXISTS ( SELECT 1
                FROM   Ac_FinancialAc
                WHERE  Name = 'OTHER SALES A/C' )
    BEGIN
        INSERT INTO Ac_FinancialAc ( Name ,
                                     PFinancialAcID ,
                                     FinancialSysID ,
                                     AddedBy ,
                                     AddedOn ,
                                     IsArchived ,
                                     IsDebit ,
                                     AccEntryType )
        VALUES ( 'OTHER SALES A/C', @salesAcId, @TransactionNodeId, 'danfe', GETDATE (), 0, 0, @AccEntryTypeId );
    END;
ELSE
    BEGIN
        UPDATE Ac_FinancialAc
        SET    FinancialSysID = @TransactionNodeId ,
               PFinancialAcID = @salesAcId ,
               IsDebit = 0 ,
               AccEntryType = @AccEntryTypeId
        WHERE  Name = 'OTHER SALES A/C';
    END;

--- add PURCHASE DISCOUNT A/C
IF NOT EXISTS ( SELECT 1
                FROM   Ac_FinancialAc
                WHERE  Name = 'PURCHASE DISCOUNT A/C' )
    BEGIN
        INSERT INTO Ac_FinancialAc ( Name ,
                                     PFinancialAcID ,
                                     FinancialSysID ,
                                     AddedBy ,
                                     AddedOn ,
                                     IsArchived ,
                                     IsDebit ,
                                     AccEntryType )
        VALUES ( 'PURCHASE DISCOUNT A/C', @salesAcId, @TransactionNodeId, 'danfe', GETDATE (), 0, 0, @AccEntryTypeId );
    END;
ELSE
    BEGIN
        UPDATE Ac_FinancialAc
        SET    FinancialSysID = @TransactionNodeId ,
               PFinancialAcID = @salesAcId ,
               IsDebit = 0 ,
               AccEntryType = @AccEntryTypeId
        WHERE  Name = 'PURCHASE DISCOUNT A/C';
    END;



