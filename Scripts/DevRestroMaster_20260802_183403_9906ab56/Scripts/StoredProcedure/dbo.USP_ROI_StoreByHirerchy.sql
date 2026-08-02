SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Drop procedure [dbo].[USP_ROI_StoreByHirerchy]
CREATE PROCEDURE [dbo].[USP_ROI_StoreByHirerchy]
as
begin

;WITH Hierarchy(ITID, ITName, PITId, Parents,[level],x)
AS
(
    SELECT STId, StName, PSTId, CAST(STId AS VARCHAR(MAX)),0,row_number()over(partition by PSTId order by StName) / power(10.0,0) as x
        FROM ROI_Store AS FirtGeneration
        WHERE isnull(PSTId,0)=0 and IsDeleted = 0
    UNION ALL
    SELECT NextGeneration.STId, NextGeneration.StName, Parent.ITID,
    CAST(CASE WHEN Parent.Parents = ''
        THEN(CAST(NextGeneration.STId AS VARCHAR(MAX)))
        ELSE(Parent.Parents + '.' + CAST(NextGeneration.PSTId AS VARCHAR(MAX)))
    END AS VARCHAR(MAX)), [level]+1,x + row_number()over(partition by  NextGeneration.PSTId order by  NextGeneration.StName) / power(10.0,level+1)
        FROM ROI_Store AS NextGeneration
        INNER JOIN Hierarchy AS Parent ON NextGeneration.PSTId = Parent.ITID    and IsDeleted = 0
)
SELECT ITID STId,ITName StName,PITId PSTId,[level] as [level],CASE [level] when 0 then ITName else REPLICATE('- - ',[level])+' '+ITName end  [PName]--,*
    FROM Hierarchy 
	order by x
	--order by Parents+'.'+CAST(ITID as varchar(20)) 
OPTION(MAXRECURSION 32767)

--;WITH StoreTree-- (STId,StName , PSTId, Level,Id)
--AS
--(
---- Anchor member definition
--SELECT STId,StName , PSTId, 0 AS Level
--FROM ROI_Store (NOLOCK)
--WHERE PSTId =0
--UNION ALL
---- Recursive member definition
--SELECT c.STId,c.StName, c.PSTId, Level + 1
--FROM ROI_Store c--
--INNER JOIN StoreTree ct
--ON c.PSTId = ct.STId
--)
--select REPLICATE('-',Level)+' '+StName as PName ,* from StoreTree
--order by STId

--SELECT Child.STId as StoreId,Child.StName, Parent.StName as PName,*
--    FROM dbo.ROI_Store AS Child
--    LEFT JOIN dbo.ROI_Store AS Parent ON Child.PSTId = Parent.STId;
--select STId as StoreId ,  PSTId, STId, StName from dbo.ROI_Store
end










GO
