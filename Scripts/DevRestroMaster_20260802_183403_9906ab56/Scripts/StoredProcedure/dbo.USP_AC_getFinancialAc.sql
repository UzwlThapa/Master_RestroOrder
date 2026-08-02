SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--EXEC
CREATE PROCEDURE [dbo].[USP_AC_getFinancialAc]
as
--DECLARE @Date datetime = '2017-04-09'
DECLARe @table table(FinancialAcID int
 , [Name] nvarchar(256)
 , PFinancialAcID int
 ,[level] int
 , Items VARCHAR(MAX),SystemGenerated BIT)  
;WITH Hierarchy(FinancialAcID, [Name], PFinancialAcID, Parents,[level],SystemGenerated)  
AS  
(  
    SELECT FinancialAcID, [Name], PFinancialAcID, CAST(FinancialAcID AS VARCHAR(MAX)),0 ,FirtGeneration.SystemGenerated 
        FROM Ac_FinancialAc AS FirtGeneration  
        WHERE isnull(PFinancialAcID,0)=0  
    UNION ALL  
    SELECT NextGeneration.FinancialAcID, NextGeneration.[Name], Parent.FinancialAcID,  
    CAST(CASE WHEN Parent.Parents = ''  
        THEN(CAST(NextGeneration.FinancialAcID AS VARCHAR(MAX)))  
        ELSE(Parent.Parents + '.' + CAST(NextGeneration.PFinancialAcID AS VARCHAR(MAX)))  
    END AS VARCHAR(MAX)), [level]+1 , NextGeneration.SystemGenerated 
        FROM Ac_FinancialAc AS NextGeneration  
        INNER JOIN Hierarchy AS Parent ON NextGeneration.PFinancialAcID = Parent.FinancialAcID      
)  
insert into @table SELECT FinancialAcID,[Name],PFinancialAcID,[level],CASE [level] when 0 then [Name] else REPLICATE('- - ',[level])+' '+[Name] end  [Items],SystemGenerated--,*  
    FROM Hierarchy order by Parents+'.'+CAST(FinancialAcID as varchar(20))  
OPTION(MAXRECURSION 32767);  
select t.FinancialAcID,t.Name as FinancialAcName, t.PFinancialAcID,t.[level],t.Items,FS.IsGroup,Fa.SystemGenerated from @table t
inner join Ac_FinancialAc Fa on t.FinancialAcID = Fa.FinancialAcID
inner join Ac_FinancialSys Fs on Fa.FinancialSysID = Fs.FinancialSysID where IsArchived = 0



GO
