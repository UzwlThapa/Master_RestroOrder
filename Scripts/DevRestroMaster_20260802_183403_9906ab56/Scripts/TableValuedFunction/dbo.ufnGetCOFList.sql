SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE FUNCTION [dbo].[ufnGetCOFList]()
RETURNS @table1 table(FinancialAcID int  
 ,[FinancialSysID] int
 ,[Name] nvarchar(256)  
 ,[PFinancialAcID] int  
 ,[level] int  
 ,[Items] VARCHAR(MAX)
 ,[IsGroup] bit,orders varchar(256))
AS 
  begin  
  declare @table table(FinancialAcID int  
 ,[FinancialSysID] int
 ,[Name] nvarchar(256)  
 ,[PFinancialAcID] int  
 ,[level] int  
 ,[Items] VARCHAR(MAX)
 ,[IsGroup] bit
	,orders varchar(256))
;WITH Hierarchy([FinancialAcID],[FinancialSysID], [Name], [PFinancialAcID], [Parents],[level])    
AS    
(    
    SELECT [FinancialAcID],[FinancialSysID], [Name], [PFinancialAcID], CAST([FinancialAcID] AS VARCHAR(MAX)),0  
        FROM [Ac_FinancialAc] AS FirtGeneration    
        WHERE isnull(PFinancialAcID,0)=0 and IsArchived = 0
    UNION ALL    
    SELECT NextGeneration.FinancialAcID,NextGeneration.[FinancialSysID], NextGeneration.[Name], Parent.FinancialAcID,    
    CAST(CASE WHEN Parent.Parents = ''    
        THEN(CAST(NextGeneration.FinancialAcID AS VARCHAR(MAX)))    
        ELSE(Parent.Parents + '.' + CAST(NextGeneration.PFinancialAcID AS VARCHAR(MAX)))    
    END AS VARCHAR(MAX)), [level]+1  
        FROM Ac_FinancialAc AS NextGeneration    
        INNER JOIN Hierarchy AS Parent ON NextGeneration.PFinancialAcID = Parent.FinancialAcID    and NextGeneration.IsArchived = 0    
)    
insert into @table SELECT FinancialAcID,[FinancialSysID],[Name],PFinancialAcID,[level],CASE [level] when 0 then [Name] else REPLICATE('- - ',[level])+' '+[Name] end  [Items],0,
Parents+'.'+CAST(FinancialAcID as varchar(20))
    FROM Hierarchy H 
	order by Parents+'.'+CAST(FinancialAcID as varchar(20))    
OPTION(MAXRECURSION 32767); 
insert into @table1 select * from @table order by orders
return
end


GO
