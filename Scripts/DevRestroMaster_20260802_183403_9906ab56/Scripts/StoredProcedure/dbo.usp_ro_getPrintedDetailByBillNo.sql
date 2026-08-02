SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_ro_getPrintedDetailByBillNo]
@billNo NVARCHAR(MAX)
AS
 SELECT * FROM dbo.PrintDetail WHERE PrintBillNo = @billNo




GO
