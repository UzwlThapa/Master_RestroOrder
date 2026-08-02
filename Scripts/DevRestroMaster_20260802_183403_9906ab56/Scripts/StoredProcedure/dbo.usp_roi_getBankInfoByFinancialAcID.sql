SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--usp_roi_getBankInfoByFinancialAcID 38
CREATE PROCEDURE [dbo].[usp_roi_getBankInfoByFinancialAcID]
@FinancialAcID int
as
select * from [dbo].[Ac_BankInfo] where FinancialAcID=@FinancialAcID



GO
