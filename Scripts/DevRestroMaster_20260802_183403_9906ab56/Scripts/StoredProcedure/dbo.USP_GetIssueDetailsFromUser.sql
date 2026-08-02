SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_GetIssueDetailsFromUser]
@ReceivedBy nvarchar(256)
AS
	SELECT I.IMId
		,I.ISNo
		,I.IssuedOn
		,I.IssuedBy
		,I.IsVerified
		,S.StName
		,St.StName AS IssToStName
		,au.UserName as ReceivedBy
	FROM DBO.ROI_IssueMain I
	LEFT JOIN DBO.ROI_Store S ON S.STId = I.IssuedFrSTId
	LEFT JOIN DBO.ROI_Store St ON St.STId = I.IssuedToSTId
	LEFt JOIN aspnet_Users au ON au.UserName= I.ReceivedBy
	where I.ReceivedBy = @ReceivedBy
	ORDER BY
		I.IssuedOn DESC
		






GO
