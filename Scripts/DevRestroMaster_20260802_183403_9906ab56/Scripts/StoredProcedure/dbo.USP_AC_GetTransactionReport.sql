SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
--  DROP PROC USP_AC_GetTransactionReport '2017-10-01' ,'2017-10-14' 
CREATE PROCEDURE [dbo].[USP_AC_GetTransactionReport]  
@From datetime  ,
@To datetime
AS  
BEGIN  
DECLARE @Result table  
 (GlID int  
 ,[GLName] nvarchar(256)  
 ,[level] int   
 ,IsGroup bit  
 ,openingBalance decimal(16,4)  
 ,DebitAmount decimal(16,4)  
 ,CreditAmount decimal(16,4)  
 ,ClosingAmount decimal(16,4))  
 Insert into @Result  
 select a.FinancialAcID,a.[Name],a.[level],fs.IsGroup,0,0,0,0 from dbo.ufnGetCOFList() a  
 inner join Ac_FinancialSys FS on a.FinancialSysID = fs.FinancialSysID  
update R  
SET R.openingBalance = Ts.Ob from @Result R   
inner join (  
select TD.FinancialAcID,SUM(TD.Debit - TD.Credit ) as OB from Ac_Transaction T inner join Ac_TransactionDetail TD on T.TransactionID = TD.TransactionID where T.TransactionDate < @From group by TD.FinancialAcID) TS   
on TS.FinancialAcID = R.GlID  
  
update R  
SET R.DebitAmount = Ts.DB ,R.CreditAmount = TS.CD from @Result R   
inner join (  
select TD.FinancialAcID,SUM(TD.Debit) as DB ,SUM( TD.Credit) as CD from Ac_Transaction T inner join Ac_TransactionDetail TD on T.TransactionID = TD.TransactionID where T.TransactionDate between @from and @To group by TD.FinancialAcID) TS   
on TS.FinancialAcID = R.GlID  
  
update R  
SET R.ClosingAmount = Ts.Ob from @Result R   
inner join (  
select TD.FinancialAcID,SUM(TD.Debit - TD.Credit) as OB from Ac_Transaction T inner join Ac_TransactionDetail TD on T.TransactionID = TD.TransactionID where T.TransactionDate <= @To group by TD.FinancialAcID) TS   
on TS.FinancialAcID = R.GlID  
  
 select * from @Result  
END  



GO
