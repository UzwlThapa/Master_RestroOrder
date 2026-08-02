SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_GetCustomerEvents]
AS
SELECT * FROM
(
select MembershipID, CONVERT(DATE,SUBSTRING(Birthday,1,6)+CAST(DATEPART(YEAR,DATEADD(MONTH,1,getdate())) as VARCHAR)) dt, FNAME+' '+LNAME as CustomerName,'Birthday' as [Event], UPPER(CONVERT(CHAR(3),CONVERT(DATE,Birthday),0))+' '+CAST(DATEPART(day,Birthday) as VARCHAR)

 as [Date],
 CASE WHEN CONVERT(DATE,SUBSTRING(Birthday,1,6)+CAST(DATEPART(YEAR,getdate()) as VARCHAR))>GETDATE()
 THEN
 DATEDIFF(day ,getdate(),
 
 CONVERT(DATE,SUBSTRING(Birthday,1,6)+CAST(DATEPART(YEAR,getdate()) as VARCHAR))

 )
 ELSE
 DATEDIFF(day ,getdate(),
 
 CONVERT(DATE,SUBSTRING(Birthday,1,6)+CAST(DATEPART(YEAR,getdate())+1 as VARCHAR))

 )
 END 
 AS  DaysRemaining
 , TelMobile
from RO_LoyaltyMembership 
where Birthday IS NOT NULL AND Birthday<>''
and SUBSTRING(Birthday,1,6)<>'02/29/'
AND CONVERT(DATE,SUBSTRING(Birthday,1,6)+CAST(DATEPART(YEAR,DATEADD(MONTH,1,getdate())) as VARCHAR)) >= CONVERT(DATE,GETDATE())
UNION ALL
select MembershipID, CONVERT(DATE,SUBSTRING(Anniversary,1,6)+CAST(DATEPART(YEAR,DATEADD(MONTH,1,getdate())) as VARCHAR)) dt, FNAME+' '+LNAME as CustomerName,'Anniversary' as [Event], UPPER(CONVERT(CHAR(3),CONVERT(DATE,Anniversary),0))+' '+CAST(DATEPART(day,Anniversary)

 as VARCHAR) as [Date],DATEDIFF(day,getdate(),CONVERT(DATE,SUBSTRING(Anniversary,1,6)+CAST(DATEPART(YEAR,getdate()) as VARCHAR))) DaysRemaining, TelMobile
from RO_LoyaltyMembership 
where Anniversary IS NOT NULL AND Anniversary<>''
and SUBSTRING(Birthday,1,6)<>'02/29/'
AND CONVERT(DATE,SUBSTRING(Anniversary,1,6)+CAST(DATEPART(YEAR,DATEADD(MONTH,1,getdate())) as VARCHAR)) >= CONVERT(DATE,GETDATE())
) x
where DaysRemaining>0 AND DaysRemaining<8
ORDER BY DaysRemaining ASC

GO
