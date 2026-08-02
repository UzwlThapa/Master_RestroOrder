SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--DROP PROCEDURE USP_GETIssueReport 
CREATE PROCEDURE [dbo].[USP_GETIssueReport] 

 @StartDate datetime,
 @EndDate datetime,
 @ISNo varchar(250),
 @itemname varchar(250)
 as
  If @itemname<>''
	SET @itemname= '%'+ @itemname+'%'
	;WITH CTE (IMId, ISNo, Qnty, ITName, Symbol, StName, IssToStName, IssuedOn, UnitDescription)
as
 (
select distinct im.IMId, im.ISNo, id.Qnty, rim.ITName, ru.Symbol, S.StName
		,St.StName AS IssToStName, im.IssuedOn, ru.UnitDescription
from  ROI_IssueMain im 
inner join ROI_IssueDetails id on im.IMId = id.IMId 
inner join  ROI_ITEMMain rim on rim.ITId = id.ITID 
LEFT JOIN DBO.ROI_Store S ON S.STId = im.IssuedFrSTId
LEFT JOIN DBO.ROI_Store St ON St.STId = im.IssuedToSTId
left join ROI_Unit1 ru on ru.Unit1Id = id.UsedUnitId
inner join ROI_Unit2 un2 ON un2.SecondUnit = ru.Unit1Id
left join ROI_Unit1 un1 on un1.Unit1Id = un2.SecondUnit
where un2.IsArchived = 0 and un1.IsArchived = 0 
union all 
select im.IMId, im.ISNo, (id.Qnty * un2.Conversion) as Qnty , rim.ITName
,un1.Symbol
, S.StName
,St.StName AS IssToStName, im.IssuedOn
,un1.UnitDescription
from  ROI_IssueMain im 
inner join ROI_IssueDetails id on im.IMId = id.IMId 
inner join  ROI_ITEMMain rim on rim.ITId = id.ITID 
LEFT JOIN DBO.ROI_Store S ON S.STId = im.IssuedFrSTId
LEFT JOIN DBO.ROI_Store St ON St.STId = im.IssuedToSTId
left join ROI_Unit1 ru on ru.Unit1Id = id.UsedUnitId
inner join ROI_Unit2 un2 ON un2.FirstUnit = ru.Unit1Id
left join ROI_Unit1 un1 on un1.Unit1Id = un2.SecondUnit
where un1.IsArchived = 0 and un2.IsArchived =0
)

select * from CTE where (cast(IssuedOn AS DATE) >= @StartDate OR @StartDate=0 OR @StartDate IS NULL OR @StartDate='')
		AND (cast(IssuedOn AS DATE)<= @EndDate OR @EndDate=0 OR @EndDate IS NULL OR @EndDate='')
		AND (ISNo = @ISNo OR @ISNo='' OR @ISNo IS NULL )
		And (ITName like @itemname OR @itemname ='' OR @itemname is null)
	 order by IMId DESC




--select im.IMId, im.ISNo, id.Qnty, rim.ITName, ru.Symbol, S.StName
--		,St.StName AS IssToStName, im.IssuedOn
--from  ROI_IssueMain im 
--inner join ROI_IssueDetails id on im.IMId = id.IMId 
--inner join  ROI_ITEMMain rim on rim.ITId = id.ITID 
--inner join ROI_Unit1 ru on ru.Unit1Id = id.UsedUnitId
--LEFT JOIN DBO.ROI_Store S ON S.STId = im.IssuedFrSTId
--LEFT JOIN DBO.ROI_Store St ON St.STId = im.IssuedToSTId
--where 1=1
--		AND  (cast(im.IssuedOn AS DATE) >= @StartDate OR @StartDate=0 OR @StartDate IS NULL OR @StartDate='')
--		AND (cast(im.IssuedOn AS DATE)<= @EndDate OR @EndDate=0 OR @EndDate IS NULL OR @EndDate='')
--		AND ( im.ISNo = @ISNo OR @ISNo='' OR @ISNo IS NULL )
--		And (rim.ITName like @itemname OR @itemname ='' OR @itemname is null)
	

GO
