SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[USP_GetSalesDetailClass]
	@salesMasterId INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

   select * from ROI_SalesStockTransaction where SalesDetailId IN (select salesDetailId from RO_SalesDetail where salesMasterId=@salesMasterId)

END

GO
