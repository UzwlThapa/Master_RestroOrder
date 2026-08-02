SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[USP_RO_GetDailyChalanReturnedDetails] 
	-- Add the parameters for the stored procedure here
	@DailyChalanId int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	--select * from DailyChalanReturnedDetail
    -- Insert statements for procedure here
	SELECT returnedID,ReturnedBy,ReturnedAmount,Remarks from DailyChalanReturnedDetail where DailyChalanId=@DailyChalanId
END




GO
