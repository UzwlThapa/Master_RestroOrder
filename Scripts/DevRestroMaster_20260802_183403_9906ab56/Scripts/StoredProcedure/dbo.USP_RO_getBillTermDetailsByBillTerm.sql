SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_RO_getBillTermDetailsByBillTerm]
@bilingID int
as

select * from dbo.RO_BillTermDetails where BilingID=@bilingID




GO
