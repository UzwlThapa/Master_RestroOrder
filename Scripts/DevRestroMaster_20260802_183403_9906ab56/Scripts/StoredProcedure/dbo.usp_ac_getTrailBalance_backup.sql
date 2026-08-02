SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- [usp_ac_getTrailBalance] '2018-08-24'
CREATE PROCEDURE [dbo].[usp_ac_getTrailBalance_backup] @Date DATETIME
AS
--DECLARE @Date datetime = '2017-04-20'  
DECLARE @table TABLE (
	FinancialAcID INT
	,[FinancialSysID] INT
	,[Name] NVARCHAR(256)
	,[PFinancialAcID] INT
	,[level] INT
	,[Items] VARCHAR(MAX)
	,[IsGroup] BIT
	);

;WITH Hierarchy (
	[FinancialAcID]
	,[FinancialSysID]
	,[Name]
	,[PFinancialAcID]
	,[Parents]
	,[level]
	)
AS (
	SELECT [FinancialAcID]
		,[FinancialSysID]
		,[Name]
		,[PFinancialAcID]
		,CAST([FinancialAcID] AS VARCHAR(MAX))
		,0
	FROM [Ac_FinancialAc] AS FirtGeneration
	WHERE isnull(PFinancialAcID, 0) = 0
		AND IsArchived = 0 
		--and (FinancialAcID=1 or FinancialAcID=2)
		
	
	UNION ALL
	
	SELECT NextGeneration.FinancialAcID
		,NextGeneration.[FinancialSysID]
		,NextGeneration.[Name]
		,Parent.FinancialAcID
		,CAST(CASE 
				WHEN Parent.Parents = ''
					THEN (CAST(NextGeneration.FinancialAcID AS VARCHAR(MAX)))
				ELSE (Parent.Parents + '.' + CAST(NextGeneration.PFinancialAcID AS VARCHAR(MAX)))                         
				END AS VARCHAR(MAX))
		,[level] + 1
	FROM Ac_FinancialAc AS NextGeneration
	INNER JOIN Hierarchy AS Parent ON NextGeneration.PFinancialAcID = Parent.FinancialAcID
		AND NextGeneration.IsArchived = 0
	)
INSERT INTO @table
SELECT FinancialAcID
	,[FinancialSysID]
	,[Name]
	,PFinancialAcID
	,[level]
	,CASE [level]
		WHEN 0
			THEN [Name]
		ELSE REPLICATE('- ', [level]) + ' ' + [Name]
		END [Items]
	,0
FROM Hierarchy H
ORDER BY Parents + '.' + CAST(FinancialAcID AS VARCHAR(20))
OPTION (MAXRECURSION 32767);

DECLARE @TableR TABLE (
	FinancialAcID INT
	,FinancialAcName NVARCHAR(256)
	,IsGroup BIT
	,Credit DECIMAL(16, 2)
	,Debit DECIMAL(16, 2)
	)

INSERT INTO @TableR
SELECT Fa.FinancialAcID
	,Fa.NAME AS FinancialAcName
	,Fs.IsGroup
	,SUM(ISNULL(AD.Credit, 0)) AS Credit
	,SUM(ISNULL(AD.Debit, 0)) AS Debit
FROM Ac_FinancialAc Fa
INNER JOIN Ac_FinancialSys Fs ON Fa.FinancialSysID = Fs.FinancialSysID
INNER JOIN Ac_TransactionDetail AD ON Fa.FinancialAcID = AD.FinancialAcID
INNER JOIN Ac_Transaction TM ON TM.TransactionID = AD.TransactionID
WHERE TM.TransactionDate between  (select StartDate from RO_fiscalYear where @Date between StartDate and EndDate) and @Date
GROUP BY Fa.FinancialAcID
	,Fa.NAME
	,Fs.IsGroup

SELECT t.FinancialAcID
	,T.NAME AS FinancialAcName
	,T.PFinancialAcID
	,T.LEVEL
	,T.Items
	,fs.IsGroup
	,ISNULL(Tr.Credit, 0) AS Credit
	,ISNULL(Tr.Debit, 0) AS Debit
FROM @table t
INNER JOIN Ac_FinancialSys FS ON t.FinancialSysID = FS.FinancialSysID
LEFT JOIN @TableR TR ON t.FinancialAcID = Tr.FinancialAcID



GO
