SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--DROP PROC [dbo].[usp_getBillterm]
CREATE PROCEDURE [dbo].[usp_getBillterm]
AS
BEGIN
	SELECT * FROM RO_BillTerm bt order by bt.Name
END




GO
