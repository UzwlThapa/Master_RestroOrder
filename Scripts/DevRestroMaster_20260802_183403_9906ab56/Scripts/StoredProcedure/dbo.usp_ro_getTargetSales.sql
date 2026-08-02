SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_ro_getTargetSales] @dates DATE
AS
BEGIN
	DECLARE @tbl TABLE (TotalSales NVARCHAR(max),Dates nvarchar(max))
	DECLARE @month INT = MONTH(@dates)
		,@day INT = day(@dates)
		,@year INT = YEAR(@dates)
	DECLARE @date DATE
	,@totalsales NVARCHAR(max)
	DECLARE @sn INT = 0

	WHILE (
			@sn < (
				SELECT max(FiscalYearID)
				FROM RO_SalesMaster
				)
			)
	BEGIN
		SET @date = (CAST(@year - @sn AS VARCHAR(4)) + RIGHT('0' + CAST(@month AS VARCHAR(2)), 2) + RIGHT('0' + CAST(@day AS VARCHAR(2)), 2))

		insert into @tbl
		SELECT sum(NetAmount)
			,CONVERT(VARCHAR(11),@date,106)
		FROM RO_SalesMaster
		WHERE CONVERT(DATE, BillDate) = @date

		SET @sn += 1
	END

	select * from @tbl
END





GO
