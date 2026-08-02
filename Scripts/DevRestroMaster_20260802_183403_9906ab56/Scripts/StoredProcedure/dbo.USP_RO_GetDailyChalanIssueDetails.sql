SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[USP_RO_GetDailyChalanIssueDetails] 
	-- Add the parameters for the stored procedure here
	@DailyChalanId int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	--select * from DailyChalanIssueDetails
    -- Insert statements for procedure here
	SELECT issueID,IssuedBy,IssuedAmount,[For] from DailyChalanIssueDetails where DailyChalanId=@DailyChalanId
END




GO
