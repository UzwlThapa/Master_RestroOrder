SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
    
--   USP_AC_GetTransactionDetailReport '2017-03-14','2017-05-14',10    
CREATE PROCEDURE [dbo].[USP_AC_GetTransactionDetailReport]    
@From datetime    
,@to datetime    
,@GLID int  
AS    
BEGIN    
DECLARE @resultTable TABLE(id  int IDENTITY(1,1) NOT NULL,TransactionID int,TransactionDetailID int,[Date] date,VoucherNo varchar(25),[Descriptions] nvarchar(256),[Particulars]nvarchar(256),Debit decimal(16,4),credit decimal(16,4),Balance decimal(16,4))  


insert into @resultTable  
select 0,0, @From,'','Opening Balance','',0,0,SUM(TD.Debit)-SUM(TD.Credit) from Ac_Transaction  T  
inner join Ac_TransactionDetail TD on T.TransactionID = TD.TransactionID  
where T.TransactionDate < @From  
and TD.FinancialAcID = @GLID  

insert into @resultTable  
select T.TransactionID,TD.TransactionDetailID, T.TransactionDate,T.VoucherNo,T.Descriptions,TD.Particulars,TD.Debit,TD.Credit,0 from Ac_Transaction  T  
inner join Ac_TransactionDetail TD on T.TransactionID = TD.TransactionID  
where (T.TransactionDate between @From and @to)
and TD.FinancialAcID = @GLID  
select t1.id, t1.TransactionID,t1.TransactionDetailID,t1.[Date],t1.VoucherNo,T1.Descriptions,T1.Particulars,t1.Debit,t1.credit, ISNULL(SUM(t2.Balance+t2.Debit-t2.credit),0) as Balance  
from @resultTable t1  
inner join @resultTable t2 on t1.id >= t2.id  
group by t1.id, t1.TransactionID,t1.TransactionDetailID,t1.[Date],t1.VoucherNo,T1.Descriptions,T1.Particulars,t1.Debit,t1.credit  
order by t1.[Date]
--t1.id  
END 


GO
