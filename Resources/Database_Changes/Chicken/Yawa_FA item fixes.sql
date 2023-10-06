 
 
DECLARE @AccEntryTypeId int 
SELECT @AccEntryTypeId  = Id from Ac_EntryType where AccountEntryType = 'Profit & Loss A/C'

DECLARE @TransactionNodeId int 
SELECT @TransactionNodeId  = FinancialSysID from Ac_FinancialSys where Name = 'Transaction Node'
DECLARE @GroupNodeId int 
SELECT @GroupNodeId  = FinancialSysID from Ac_FinancialSys where Name = 'Group Node'

 /* 
	 -- EXPENSES 
	 -- REGULAR PURCHASE A/C
 */

DECLARE @ExpensesId int
SELECT @ExpensesId  = FinancialAcID from Ac_FinancialAc where Name = 'EXPENSES'

--- add DIRECT EXPENSES A/C
if not exists(select 1 from Ac_FinancialAc where name = 'DIRECT EXPENSES')
begin
INSERT INTO Ac_FinancialAc(Name,PFinancialAcID,FinancialSysID,AddedBy,AddedOn,IsArchived,IsDebit,AccEntryType) 
VALUES('DIRECT EXPENSES',@ExpensesId,@GroupNodeId,'danfe',GETDATE(),0,1,@AccEntryTypeId);
end
else
begin
UPDATE Ac_FinancialAc SET FinancialSysID = @GroupNodeId,PFinancialAcID = @ExpensesId,IsDebit = 1,AccEntryType = @AccEntryTypeId WHERE name ='DIRECT EXPENSES'
end
 
DECLARE @DirectExpensesId int 
SELECT @DirectExpensesId  = FinancialAcID from Ac_FinancialAc where Name = 'DIRECT EXPENSES'

 --- add REGULAR PURCHASE A/C
if not exists(select 1 from Ac_FinancialAc where name = 'REGULAR PURCHASE A/C')
begin
INSERT INTO Ac_FinancialAc(Name,PFinancialAcID,FinancialSysID,AddedBy,AddedOn,IsArchived,IsDebit,AccEntryType) 
VALUES('REGULAR PURCHASE A/C',@DirectExpensesId,@GroupNodeId,'danfe',GETDATE(),0,1,@AccEntryTypeId);
end
else
begin
UPDATE Ac_FinancialAc SET FinancialSysID = @GroupNodeId,PFinancialAcID = @DirectExpensesId,IsDebit = 1,AccEntryType = @AccEntryTypeId WHERE name ='REGULAR PURCHASE A/C'
end
 
DECLARE @RegularPurchaseId int 
SELECT @RegularPurchaseId  = FinancialAcID from Ac_FinancialAc where Name = 'REGULAR PURCHASE A/C'
   
--- add Jaar water
if not exists(select 1 from Ac_FinancialAc where name = 'JAAR WATER')
begin
INSERT INTO Ac_FinancialAc(Name,PFinancialAcID,FinancialSysID,AddedBy,AddedOn,IsArchived,IsDebit,AccEntryType) 
VALUES('JAAR WATER',@RegularPurchaseId,@TransactionNodeId,'danfe',GETDATE(),0,1,@AccEntryTypeId);
end
else
begin
UPDATE Ac_FinancialAc SET FinancialSysID = @TransactionNodeId,PFinancialAcID = @RegularPurchaseId,IsDebit = 1,AccEntryType = @AccEntryTypeId WHERE name ='JAAR WATER'
end

 -- add pop up
if not exists(select 1 from Ac_FinancialAc where name = 'pop up')
begin
INSERT INTO Ac_FinancialAc(Name,PFinancialAcID,FinancialSysID,AddedBy,AddedOn,IsArchived,IsDebit,AccEntryType) 
VALUES('pop up',@RegularPurchaseId,@TransactionNodeId,'danfe',GETDATE(),0,1,@AccEntryTypeId);
end
else
begin
UPDATE Ac_FinancialAc SET FinancialSysID = @TransactionNodeId,PFinancialAcID = @RegularPurchaseId,IsDebit = 1,AccEntryType = @AccEntryTypeId WHERE name ='pop up'
end

 -- add Office Expenses
if not exists(select 1 from Ac_FinancialAc where name = 'Office Expenses')
begin
INSERT INTO Ac_FinancialAc(Name,PFinancialAcID,FinancialSysID,AddedBy,AddedOn,IsArchived,IsDebit,AccEntryType) 
VALUES('Office Expenses',@RegularPurchaseId,@TransactionNodeId,'danfe',GETDATE(),0,1,@AccEntryTypeId);
end
else
begin
UPDATE Ac_FinancialAc SET FinancialSysID = @TransactionNodeId,PFinancialAcID = @RegularPurchaseId,IsDebit = 1,AccEntryType = @AccEntryTypeId WHERE name ='Office Expenses'
end

 -- add Fruit Shop
if not exists(select 1 from Ac_FinancialAc where name = 'Fruit Shop')
begin
INSERT INTO Ac_FinancialAc(Name,PFinancialAcID,FinancialSysID,AddedBy,AddedOn,IsArchived,IsDebit,AccEntryType) 
VALUES('Fruit Shop',@RegularPurchaseId,@TransactionNodeId,'danfe',GETDATE(),0,1,@AccEntryTypeId);
end
else
begin
UPDATE Ac_FinancialAc SET FinancialSysID = @TransactionNodeId,PFinancialAcID = @RegularPurchaseId,IsDebit = 1,AccEntryType = @AccEntryTypeId WHERE name ='Fruit Shop'
end

 -- add  Staff Fooding
if not exists(select 1 from Ac_FinancialAc where name = 'Staff Fooding')
begin
INSERT INTO Ac_FinancialAc(Name,PFinancialAcID,FinancialSysID,AddedBy,AddedOn,IsArchived,IsDebit,AccEntryType) 
VALUES('Staff Fooding',@RegularPurchaseId,@TransactionNodeId,'danfe',GETDATE(),0,1,@AccEntryTypeId);
end
else
begin
UPDATE Ac_FinancialAc SET FinancialSysID = @TransactionNodeId,PFinancialAcID = @RegularPurchaseId,IsDebit = 1,AccEntryType = @AccEntryTypeId WHERE name ='Staff Fooding'
end


--- add BAR PURCHASE A/C
if not exists(select 1 from Ac_FinancialAc where name = 'BAR PURCHASE A/C')
begin
INSERT INTO Ac_FinancialAc(Name,PFinancialAcID,FinancialSysID,AddedBy,AddedOn,IsArchived,IsDebit,AccEntryType) 
VALUES('BAR PURCHASE A/C',@DirectExpensesId,@GroupNodeId,'danfe',GETDATE(),0,1,@AccEntryTypeId);
end
else
begin
UPDATE Ac_FinancialAc SET FinancialSysID = @GroupNodeId,PFinancialAcID = @DirectExpensesId,IsDebit = 1,AccEntryType = @AccEntryTypeId WHERE name ='BAR PURCHASE A/C'
end
 
declare @BARPurchaseId int;
SELECT @BARPurchaseId  = FinancialAcID from Ac_FinancialAc where Name = 'BAR PURCHASE A/C'


--- add TOBACCO PURCHASE A/C
if not exists(select 1 from Ac_FinancialAc where name = 'TOBACCO PURCHASE A/C')
begin
INSERT INTO Ac_FinancialAc(Name,PFinancialAcID,FinancialSysID,AddedBy,AddedOn,IsArchived,IsDebit,AccEntryType) 
VALUES('TOBACCO PURCHASE A/C',@BARPurchaseId,@TransactionNodeId,'danfe',GETDATE(),0,1,@AccEntryTypeId);
end
else
begin
UPDATE Ac_FinancialAc SET FinancialSysID = @TransactionNodeId,PFinancialAcID = @BarPurchaseId,IsDebit = 1,AccEntryType = @AccEntryTypeId WHERE name ='TOBACCO PURCHASE A/C'
end 

--- add FOOD PURCHASE A/C
if not exists(select 1 from Ac_FinancialAc where name = 'FOOD PURCHASE A/C')
begin
INSERT INTO Ac_FinancialAc(Name,PFinancialAcID,FinancialSysID,AddedBy,AddedOn,IsArchived,IsDebit,AccEntryType) 
VALUES('FOOD PURCHASE A/C',@DirectExpensesId,@TransactionNodeId,'danfe',GETDATE(),0,1,@AccEntryTypeId);
end
else
begin
UPDATE Ac_FinancialAc SET FinancialSysID = @TransactionNodeId,PFinancialAcID = @DirectExpensesId,IsDebit = 1,AccEntryType = @AccEntryTypeId WHERE name ='FOOD PURCHASE A/C'
end


 /* 
	 -- EXPENSES 
	 -- SALARY EXPENSES
 */

DECLARE @ExpensesId int
SELECT @ExpensesId  = FinancialAcID from Ac_FinancialAc where Name = 'EXPENSES'

--- add DIRECT EXPENSES
if not exists(select 1 from Ac_FinancialAc where name = 'SALARY EXPENSES')
begin
INSERT INTO Ac_FinancialAc(Name,PFinancialAcID,FinancialSysID,AddedBy,AddedOn,IsArchived,IsDebit,AccEntryType) 
VALUES('SALARY EXPENSES',@ExpensesId,@GroupNodeId,'danfe',GETDATE(),0,1,@AccEntryTypeId);
end
else
begin
UPDATE Ac_FinancialAc SET FinancialSysID = @GroupNodeId,PFinancialAcID = @ExpensesId,IsDebit = 1,AccEntryType = @AccEntryTypeId WHERE name ='SALARY EXPENSES'
end
 
DECLARE @SalaryExpensesId int 
SELECT @SalaryExpensesId  = FinancialAcID from Ac_FinancialAc where Name = 'SALARY EXPENSES'

 --- add Salary A/C
if not exists(select 1 from Ac_FinancialAc where name = 'Salary A/C')
begin
INSERT INTO Ac_FinancialAc(Name,PFinancialAcID,FinancialSysID,AddedBy,AddedOn,IsArchived,IsDebit,AccEntryType) 
VALUES('Salary A/C',@SalaryExpensesId,@TransactionNodeId,'danfe',GETDATE(),0,1,@AccEntryTypeId);
end
else
begin
UPDATE Ac_FinancialAc SET FinancialSysID = @TransactionNodeId,PFinancialAcID = @SalaryExpensesId,IsDebit = 1,AccEntryType = @AccEntryTypeId WHERE name ='Salary A/C'
end
 

 
--- add TOTAL DISCOUNT
if not exists(select 1 from Ac_FinancialAc where name = 'TOTAL DISCOUNT')
begin
INSERT INTO Ac_FinancialAc(Name,PFinancialAcID,FinancialSysID,AddedBy,AddedOn,IsArchived,IsDebit,AccEntryType) 
VALUES('TOTAL DISCOUNT',@ExpensesId,@GroupNodeId,'danfe',GETDATE(),0,1,@AccEntryTypeId);
end
else
begin
UPDATE Ac_FinancialAc SET FinancialSysID = @GroupNodeId,PFinancialAcID = @ExpensesId,IsDebit = 1,AccEntryType = @AccEntryTypeId WHERE name ='TOTAL DISCOUNT'
end
 
DECLARE @TotalDiscountId int 
SELECT @TotalDiscountId  = FinancialAcID from Ac_FinancialAc where Name = 'TOTAL DISCOUNT'

 --- add SALES DISCOUNT A/C
if not exists(select 1 from Ac_FinancialAc where name = 'SALES DISCOUNT A/C')
begin
INSERT INTO Ac_FinancialAc(Name,PFinancialAcID,FinancialSysID,AddedBy,AddedOn,IsArchived,IsDebit,AccEntryType) 
VALUES('SALES DISCOUNT A/C',@TotalDiscountId,@TransactionNodeId,'danfe',GETDATE(),0,1,@AccEntryTypeId);
end
else
begin
UPDATE Ac_FinancialAc SET FinancialSysID = @TransactionNodeId,PFinancialAcID = @TotalDiscountId,IsDebit = 1,AccEntryType = @AccEntryTypeId WHERE name ='SALES DISCOUNT A/C'
end
 
 
 --- add SURPLUS/DEFLICT A/C
if not exists(select 1 from Ac_FinancialAc where name = 'SURPLUS/DEFLICT A/C')
begin
INSERT INTO Ac_FinancialAc(Name,PFinancialAcID,FinancialSysID,AddedBy,AddedOn,IsArchived,IsDebit,AccEntryType) 
VALUES('SURPLUS/DEFLICT A/C',@TotalDiscountId,@TransactionNodeId,'danfe',GETDATE(),0,1,@AccEntryTypeId);
end
else
begin
UPDATE Ac_FinancialAc SET FinancialSysID = @TransactionNodeId,PFinancialAcID = @TotalDiscountId,IsDebit = 1,AccEntryType = @AccEntryTypeId WHERE name ='SURPLUS/DEFLICT A/C'
end
 


/* 
	 -- INCOME  
 */
DECLARE @salesAcId int
SELECT @salesAcId  = FinancialAcID from Ac_FinancialAc where Name = 'SALES'


--- add BAR SALES A/C
if not exists(select 1 from Ac_FinancialAc where name = 'BAR SALES A/C')
begin
INSERT INTO Ac_FinancialAc(Name,PFinancialAcID,FinancialSysID,AddedBy,AddedOn,IsArchived,IsDebit,AccEntryType) 
VALUES('BAR SALES A/C',@salesAcId,@GroupNodeId,'danfe',GETDATE(),0,0, @AccEntryTypeId);
end
else
begin
UPDATE Ac_FinancialAc SET FinancialSysID = @GroupNodeId,PFinancialAcID = @salesAcId,IsDebit = 0,AccEntryType = @AccEntryTypeId WHERE name ='BAR SALES A/C'
end
 
--- add TOBACCO SALES A/C
DECLARE @BARsalesAcId int
SELECT @BARsalesAcId  = FinancialAcID from Ac_FinancialAc where Name = 'BAR SALES A/C'
 

if not exists(select 1 from Ac_FinancialAc where name = 'TOBACCO SALES A/C')
begin
INSERT INTO Ac_FinancialAc(Name,PFinancialAcID,FinancialSysID,AddedBy,AddedOn,IsArchived,IsDebit,AccEntryType) 
VALUES('TOBACCO SALES A/C',@BARsalesAcId,@TransactionNodeId,'danfe',GETDATE(),0,0,@AccEntryTypeId);
end
else
begin
UPDATE Ac_FinancialAc SET FinancialSysID = @TransactionNodeId,PFinancialAcID = @BARsalesAcId,IsDebit = 0,AccEntryType = @AccEntryTypeId WHERE name ='TOBACCO SALES A/C'
end
 
--- add FOOD SALES A/C
if not exists(select 1 from Ac_FinancialAc where name = 'FOOD SALES A/C')
begin 
INSERT INTO Ac_FinancialAc(Name,PFinancialAcID,FinancialSysID,AddedBy,AddedOn,IsArchived,IsDebit,AccEntryType) 
VALUES('FOOD SALES A/C',@salesAcId,@TransactionNodeId,'danfe',GETDATE(),0,0,@AccEntryTypeId);
end
else
begin
UPDATE Ac_FinancialAc SET FinancialSysID = @TransactionNodeId,PFinancialAcID = @salesAcId,IsDebit = 0,AccEntryType = @AccEntryTypeId WHERE name ='FOOD SALES A/C'
end

--- add OTHER SALES A/C
if not exists(select 1 from Ac_FinancialAc where name = 'OTHER SALES A/C')
begin
INSERT INTO Ac_FinancialAc(Name,PFinancialAcID,FinancialSysID,AddedBy,AddedOn,IsArchived,IsDebit,AccEntryType) 
VALUES('OTHER SALES A/C',@salesAcId,@TransactionNodeId,'danfe',GETDATE(),0,0,@AccEntryTypeId);
end
else
begin
UPDATE Ac_FinancialAc SET FinancialSysID = @TransactionNodeId,PFinancialAcID = @salesAcId,IsDebit = 0,AccEntryType = @AccEntryTypeId WHERE name ='OTHER SALES A/C'
end
  
--- add PURCHASE DISCOUNT A/C
if not exists(select 1 from Ac_FinancialAc where name = 'PURCHASE DISCOUNT A/C')
begin
INSERT INTO Ac_FinancialAc(Name,PFinancialAcID,FinancialSysID,AddedBy,AddedOn,IsArchived,IsDebit,AccEntryType) 
VALUES('PURCHASE DISCOUNT A/C',@salesAcId,@TransactionNodeId,'danfe',GETDATE(),0,0,@AccEntryTypeId);
end
else
begin
UPDATE Ac_FinancialAc SET FinancialSysID = @TransactionNodeId,PFinancialAcID = @salesAcId,IsDebit = 0,AccEntryType = @AccEntryTypeId WHERE name ='PURCHASE DISCOUNT A/C'
end
 
   
delete d from Ac_FinancialAc  d where   Name = 'SERVICES' and AccEntryType = @AccEntryTypeId
delete d from Ac_FinancialAc  d where   Name = 'BAR SALES A/C' and PFinancialAcID = @RegularPurchaseId and AccEntryType = @AccEntryTypeId
delete d from Ac_FinancialAc  d where   Name  like '%Staff%' and PFinancialAcID = @RegularPurchaseId and AddedBy = 'danfe'  and AccEntryType = @AccEntryTypeId
 
  
DELETE  a
from Ac_FinancialAc A where name IN('BAR EXPENSES' ,'CAFE SALES A/C','COMBO SALES A/C') and AccEntryType = @AccEntryTypeId;
 

  