SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_SaleReportByProviderList]
@id INT,
@ProviderId INT,
@TodayDate DATE,
@WeeklyDate DATE,
@Month INT,
@Year INT
AS
BEGIN
	IF(@id = 1)
begin  
	SELECT SUM(sm.NetAmount) AS Amount,CAST(sm.BillDate AS date) AS BillDate FROM RO_SalesMaster sm 
	 WHERE CAST(sm.BillDate AS date)= @Todaydate AND sm.ProviderID = @ProviderId GROUP BY CAST(sm.BillDate AS date) 
END
	 ELSE IF(@id = 2 )
BEGIN
	SELECT SUM(sm.NetAmount) AS Amount,CAST(sm.BillDate AS date) AS BillDate FROM RO_SalesMaster sm 
	 WHERE CAST(sm.BillDate AS date) BETWEEN DATEADD(d,-7,@Weeklydate) AND  @Weeklydate AND  sm.ProviderID = @ProviderId GROUP BY CAST(sm.BillDate AS date) 
END
ELSE IF(@id = 3)
BEGIN
	SELECT SUM(sm.NetAmount) AS Amount,CAST(sm.BillDate AS date) AS BillDate FROM RO_SalesMaster sm 
	 WHERE MONTH(sm.BillDate) =@month  AND  YEAR(sm.BillDate) = @year AND  sm.ProviderID = @ProviderId GROUP BY CAST(sm.BillDate AS date) 
END
ELSE 
BEGIN
	SELECT sm.NetAmount AS Amount,cast(sm.BillDate as varchar(12)) as Date FROM RO_SalesMaster sm 
	 WHERE  YEAR(sm.BillDate) = @year  AND  sm.ProviderID = @ProviderId  
END
END




GO
