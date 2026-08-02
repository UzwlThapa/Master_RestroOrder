SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_SaleReportByPayementMode]  --3,1,'01/06/2016','',0,0
@mode int,
@id INT ,
@TodayDate DATE,
@WeeklyDate DATE,
@Month INT,
@Year INT
AS 
begin 
IF(@mode = 3)
BEGIN
	IF(@id = 1)
begin  

	SELECT SUM(sm.NetAmount) AS Amount,CAST(sm.BillDate AS date) AS BillDate,p.ProviderName 
	FROM RO_SalesMaster sm INNER JOIN
	RO_CardProvider p ON p.ProviderID = sm.ProviderID
	 WHERE CAST(sm.BillDate AS date)= @Todaydate AND sm.SPMID =@mode GROUP BY CAST(sm.BillDate AS date),p.ProviderName 
END
	 ELSE IF(@id = 2 )
BEGIN
	SELECT SUM(sm.NetAmount) AS Amount,CAST(sm.BillDate AS date) AS BillDate,p.ProviderName 
	FROM RO_SalesMaster sm INNER JOIN
	RO_CardProvider p ON p.ProviderID = sm.ProviderID
	 WHERE CAST(sm.BillDate AS date) BETWEEN DATEADD(d,-7,@Weeklydate) AND  @Weeklydate AND sm.SPMID = @mode 
	 GROUP BY CAST(sm.BillDate AS date),p.ProviderName 
END
ELSE IF(@id = 3)
BEGIN
	SELECT SUM(sm.NetAmount) AS Amount,CAST(sm.BillDate AS date) AS BillDate,p.ProviderName 
	FROM RO_SalesMaster sm INNER JOIN
	RO_CardProvider p ON p.ProviderID = sm.ProviderID
	 WHERE Month(sm.BillDate)=@month  AND  YEAR(sm.BillDate) = @year AND sm.SPMID = @mode 
	 GROUP BY CAST(sm.BillDate AS date),p.ProviderName 
END
ELSE 
BEGIN
	SELECT SUM(sm.NetAmount) AS Amount,CAST(sm.BillDate AS date) AS BillDate,p.ProviderName 
	FROM RO_SalesMaster sm INNER JOIN
	RO_CardProvider p ON p.ProviderID = sm.ProviderID
	 WHERE  YEAR(sm.BillDate) = @year AND sm.SPMID = @mode AND sm.SPMID = @mode  GROUP BY CAST(sm.BillDate AS date),p.ProviderName   
END
END

ELSE
BEGIN
IF(@id = 1)
begin  

	SELECT SUM(sm.NetAmount) AS Amount,CAST(sm.BillDate AS date) AS BillDate FROM RO_SalesMaster sm 
	 WHERE CAST(sm.BillDate AS date)= @Todaydate AND sm.SPMID =@mode GROUP BY CAST(sm.BillDate AS date)
END
	 ELSE IF(@id = 2 )
BEGIN
	SELECT SUM(sm.NetAmount) AS Amount,CAST(sm.BillDate AS date) AS BillDate FROM RO_SalesMaster sm 
	 WHERE CAST(sm.BillDate AS date) BETWEEN DATEADD(d,-7,@Weeklydate) AND  @Weeklydate AND sm.SPMID = @mode 
	 GROUP BY CAST(sm.BillDate AS date)
END
ELSE IF(@id = 3)
BEGIN
	SELECT SUM(sm.NetAmount) AS Amount,CAST(sm.BillDate AS date) AS BillDate FROM RO_SalesMaster sm 
	 WHERE Month(sm.BillDate)=@month  AND  YEAR(sm.BillDate) = @year AND sm.SPMID = @mode 
	 GROUP BY CAST(sm.BillDate AS date)
END
ELSE 
BEGIN
	SELECT SUM(sm.NetAmount) AS Amount,CAST(sm.BillDate AS date) AS BillDate FROM RO_SalesMaster sm 
	 WHERE  YEAR(sm.BillDate) = @year AND sm.SPMID = @mode AND sm.SPMID = @mode  GROUP BY CAST(sm.BillDate AS date)  
END
	
END
	
END











GO
