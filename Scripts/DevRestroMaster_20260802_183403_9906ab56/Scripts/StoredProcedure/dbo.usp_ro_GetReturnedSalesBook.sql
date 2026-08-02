SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--- exec usp_ro_GetReturnedSalesBook '2074.12.12','2075.12.30'
CREATE PROCEDURE [dbo].[usp_ro_GetReturnedSalesBook] @FromDate NVARCHAR(256)	,@ToDate NVARCHAR(256)
AS
SELECT *
FROM CBMS_BillReturnPostLog
WHERE credit_note_date BETWEEN REPLACE(@FromDate,'-','.') AND REPLACE(@ToDate,'-','.')



GO
