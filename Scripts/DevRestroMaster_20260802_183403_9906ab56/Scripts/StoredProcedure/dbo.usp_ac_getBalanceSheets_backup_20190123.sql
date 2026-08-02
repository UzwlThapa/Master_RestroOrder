SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- [usp_ac_getTrailBalance] '2011-01-05'  
--drop  PROCEDURE [dbo].[usp_ac_getBalanceSheets]
CREATE PROCEDURE [dbo].[usp_ac_getBalanceSheets_backup_20190123] @Date DATETIME  
AS  
--DECLARE @Date datetime = '2018-08-24'  
 
 DECLARE @StartDate date 
select @StartDate= StartDate from RO_fiscalYear where @Date between StartDate and EndDate
  
  if OBJECT_ID('tempdb.dbo.#Temp_AccountHead_Balance','U') is not null  
  drop table #Temp_AccountHead_Balance;  

  if OBJECT_ID('tempdb.dbo.#Temp_TrialBalance','U') is not null  
  drop table #Temp_TrialBalance  
  

;WITH Hierarchy (  
 [FinancialAcID]  
 ,[FinancialSysID]  
 ,[Name]  
 ,[PFinancialAcID]  
 ,[Parents]  
 ,[level]  
 ,GroupFinancialAcID  
 )  
AS (  
 SELECT [FinancialAcID]  
  ,[FinancialSysID]  
  ,[Name]  
  ,[PFinancialAcID]  
  ,CAST([FinancialAcID] AS VARCHAR(MAX))  
  ,0 as Level  
  ,[FinancialAcID] as GroupFinancialAcID  
 FROM [Ac_FinancialAc] AS FirtGeneration  
 WHERE isnull(PFinancialAcID, 0) = 0  
  AND IsArchived = 0   
  and (FinancialAcID=1 or FinancialAcID=2)      
   
 UNION ALL  
   
 SELECT NextGeneration.FinancialAcID  
  ,NextGeneration.[FinancialSysID]  
  ,NextGeneration.[Name]  
  ,Parent.FinancialAcID  
  ,CAST(CASE   WHEN Parent.Parents = ''  THEN (CAST(NextGeneration.FinancialAcID AS VARCHAR(MAX)))  
				ELSE (Parent.Parents + '.' + CAST(NextGeneration.PFinancialAcID AS VARCHAR(MAX)))                           
		END AS VARCHAR(MAX))  
  ,[level] + 1  
  ,CASE WHEN (isnull(NextGeneration.IsShownInBalanceSheet,0)=1) THEN NextGeneration.FinancialAcID ELSE Parent.GroupFinancialAcID END  
 FROM Ac_FinancialAc AS NextGeneration   
 --INNER JOIN Ac_FinancialSys as fs on NextGeneration.FinancialSysID=fs.FinancialSysID  
 INNER JOIN Hierarchy AS Parent ON NextGeneration.PFinancialAcID = Parent.FinancialAcID  
  AND NextGeneration.IsArchived = 0  
 )   
  
SELECT a.[FinancialAcID]  
 ,[FinancialSysID]  
 ,[Name]  
 ,[PFinancialAcID]  
 ,[Parents]  
 ,[level]  
 ,GroupFinancialAcID  
 ,sum(Debit) Debit  
  ,sum(Credit) Credit  
INTO #Temp_AccountHead_Balance  
  FROM Hierarchy a  
left join Ac_TransactionDetail td on a.FinancialAcID = td.FinancialAcID  
left JOIN Ac_Transaction TM ON TM.TransactionID = td.TransactionID  
WHERE TM.TransactionDate between  @StartDate and @Date  
GROUP BY a.[FinancialAcID]  
 ,[FinancialSysID]  
 ,[Name]  
 ,[PFinancialAcID]  
 ,[Parents]  
 ,[level]  
 ,GroupFinancialAcID  
  
 --select * from #Temp_AccountHead_Balance  
  
 select a.FinancialAcID,a.Name, a.PFinancialAcID  
 ,CASE WHEN isnull([level],0) = 0 and a.PFinancialAcID = 0  THEN a.Name  
	   WHEN isnull([level],0) = 0 and a.PFinancialAcID > 0  THEN REPLICATE('-- ', 1) + ' ' + a.Name  
	   ELSE REPLICATE('-- ', [level]) + ' ' + a.Name  
  END [Items]  
  ,fs.IsGroup  
  ,b.GroupFinancialAcID  
  ,isnull(b.[level],0) as [LEVEL]  
 , b.Credit  
 ,b.Debit   
 into #Temp_TrialBalance  
 FROM Ac_FinancialAc a  
 INNER JOIN Ac_FinancialSys as fs on a.FinancialSysID=fs.FinancialSysID  
 LEFT JOIN (  
SELECT GroupFinancialAcID,[level]  
 ,sum(Debit) Debit  
  ,sum(Credit) Credit   
  FROM #Temp_AccountHead_Balance  
  GROUP BY  GroupFinancialAcID,[level]  
  ) b ON a.FinancialAcID=b.GroupFinancialAcID  
  WHERE (fs.IsGroup=1 or b.Debit is not null) and isnull(a.IsArchived,0) = 0  
  and (FinancialAcID=1 or FinancialAcID=2 or PFinancialAcID > 0)  
 
  ;with cte(FinancialAcID,Name,PFinancialAcID,Items,IsGroup,GroupFinancialAcID,[LEVEL],Credit,Debit,AcOrder )  
 as  
 ( select FinancialAcID,Name,PFinancialAcID,Items,IsGroup,GroupFinancialAcID,[LEVEL],Credit,Debit  
	 ,Row_Number() over (order by Name)*1000 as AcOrder  
	 from #Temp_TrialBalance  
	 where PFinancialAcID=0  
	 union all  
	 select tb.FinancialAcID,tb.Name,tb.PFinancialAcID,tb.Items,tb.IsGroup,tb.GroupFinancialAcID,tb.[LEVEL],tb.Credit,tb.Debit  
	 ,p.AcOrder+ Row_Number() over (order by tb.Name)*100 as AcOrder  
	 from #Temp_TrialBalance tb  
	 INNER JOIN CTE p on tb.PFinancialAcID=p.FinancialAcID  
	 where tb.PFinancialAcID<=4  
	 union all  
	 select tb.FinancialAcID,tb.Name,tb.PFinancialAcID,tb.Items,tb.IsGroup,tb.GroupFinancialAcID,tb.[LEVEL],tb.Credit,tb.Debit  
	 ,p.AcOrder+ Row_Number() over (order by tb.Name)*10 as AcOrder  
	 from #Temp_TrialBalance tb  
	 INNER JOIN CTE p on tb.PFinancialAcID=p.FinancialAcID  
	 where tb.PFinancialAcID>=5  
 )  
      
 select FinancialAcID,Name,PFinancialAcID,Items,IsGroup,GroupFinancialAcID,[LEVEL],isnull(Credit,0) as Credit,isnull(Debit,0) as Debit  
  from cte order by AcOrder  
--select * from Ac_FinancialAc   
  
  
--select * from Ac_TransactionDetail

GO
