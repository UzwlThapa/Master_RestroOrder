CREATE PROCEDURE USP_GetIssueDetails
@IMId INT
AS
BEGIN

SELECT rm.IMId, rm.ISNo, rm.IssuedToSTId, rm.IssuedFrSTId, rm.IssuedOn, rid.IDId, rid.ITID, rid.UsedUnitId, rid.Qnty, S.StName, S.PSTId,
                         St.StName AS IssToStName, ru.Unit1Id, ru.Symbol, im.ITName, im.PITId, S.IsActive, ru.UnitDescription
FROM            ROI_IssueMain AS rm Left JOIN
             ROI_IssueDetails AS rid ON rm.IMId = rid.IMId Left JOIN
            ROI_Store AS S ON S.STId = rm.IssuedFrSTId LEFT OUTER JOIN
            ROI_Store AS St ON St.STId = rm.IssuedToSTId LEFT OUTER JOIN
            ROI_Unit1 AS ru ON ru.Unit1Id = rid.UsedUnitId LEFT OUTER JOIN
            ROI_ITEMMain AS im ON im.ITId = rid.ITID
where rm.IMId = @IMId

END