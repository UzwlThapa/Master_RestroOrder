SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_GetOrderCancelResponsible]
as BEGIN
SELECT distinct
	odc.Responsible
FROM dbo.Order_Detail_Cancel odc
where Responsible is not null and Responsible != ''
UNION

SELECT distinct
	rom.UserName AS Waiter	
FROM dbo.RO_OrderMasters rom
where UserName  is not null and UserName != ''
END


GO
