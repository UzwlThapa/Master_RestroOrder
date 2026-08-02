SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_UpdateVerification]
@IMId int
AS
BEGIN
update ROI_IssueMain set IsVerified= 1, VerifiedOn=getdate() where IMId=@IMId
END

GO
