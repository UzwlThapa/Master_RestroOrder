SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--DROP PROCEDURE [USP_GetAllItemforCategoryHirerchy]
CREATE PROCEDURE [dbo].[USP_GetAllItemforCategoryHirerchy]
@IsMenu bit=null,
@CategoryLevel int =999
as
BEGIN
--select  *,
-- (select ITName from ROI_ITEMMain where ITId = im.PITId) as ParentItem 
-- from ROI_ITEMMain im 
--  join ROI_ItemDetails id on id.ITId = im.ITId
-- join CostCenterInfo cci on cci.CostCenterId= id.ItemCostCentreID
-- where im.IsArchived=0 and im.IsCategory=1
-- --  and id.IsMenu=1
;WITH CTE(ITId, ITName, PITId, IsActive, IsMenu, IsCategory, CategoryOrder, CategoryLevel)  
as  
(  
SELECT        c.ITId, c.ITName, c.PITId, c.IsActive, c.IsMenu, c.IsCategory,CAST(Row_Number() over (order by c.ITName)*1000000000000 as BIGINT) , 0  
FROM            ROI_ITEMMain AS c  
inner join ROI_ItemDetails id on c.ITId=id.ITId and c.IsCategory=1 and (c.IsMenu=@IsMenu OR @IsMenu IS NULL) and c.IsArchived=0 and c.PITId=0  
UNION ALL  
SELECT         c.ITId, c.ITName, c.PITId, c.IsActive, c.IsMenu, c.IsCategory  
,CAST(p.CategoryOrder + (Row_Number() over (order by c.ITName)*CAST(LEFT('100000000000',8-p.CategoryLevel*2) as BIGINt))  as BIGINT)
, p.CategoryLevel+1  
FROM            ROI_ITEMMain AS c  
inner join ROI_ItemDetails id on c.ITId=id.ITId and c.IsCategory=1 and (c.IsMenu=@IsMenu OR @IsMenu IS NULL) and c.IsArchived=0 
INNER JOIN CTE p on c.PITId=p.ITId  
)  
SELECT CTE.ITId,dbo.fn_LevelPrefix(CTE.CategoryLevel,'----')+cte.ITName ITName, CTE.PITId, CTE.IsActive, CTE.IsMenu, CTE.IsCategory, d.*, cc.* , parent.ITName as  ParentItem  
FROM CTE  
INNER JOIN ROI_ItemDetails d ON CTE.ITId=d.ITId and d.IsArchived=0   
INNER JOIN dbo.CostCenterInfo cc on cc.CostCenterId=d.ItemCostCentreID  
LEFT JOIN ROI_ITEMMain parent on parent.ITId=cte.PITId  
WHERE (cte.IsMenu=@IsMenu OR @IsMenu IS NULL)  
AND cte.CategoryLevel<=@CategoryLevel  
ORDER BY CategoryOrder  

end


GO
