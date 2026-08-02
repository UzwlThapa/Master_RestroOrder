SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_RO_StoreAmountDetails]
	-- Add the parameters for the stored procedure here
	@Amount float
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	Insert into DailyOrderDetailsTotal (Amount) values (@Amount)
END




GO
