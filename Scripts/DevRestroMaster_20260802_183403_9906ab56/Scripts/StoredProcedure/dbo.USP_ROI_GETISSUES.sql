SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_ROI_GETISSUES]
AS
BEGIN
	SELECT I.IMId
		,I.ISNo
		,I.IssuedFrSTId
		,I.IssuedToSTId
		,cast(I.IssuedOn as date) as IssuedOn
		--,I.IssuedOn
		,I.IssuedBy
		,S.StName
		,St.StName AS IssToStName
	FROM DBO.ROI_IssueMain I
	LEFT JOIN DBO.ROI_Store S ON S.STId = I.IssuedFrSTId
	LEFT JOIN DBO.ROI_Store St ON St.STId = I.IssuedToSTId
	ORDER BY IMID DESC
END



GO
