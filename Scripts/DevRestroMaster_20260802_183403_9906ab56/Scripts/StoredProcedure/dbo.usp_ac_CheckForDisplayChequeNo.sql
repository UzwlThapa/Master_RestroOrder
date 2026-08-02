SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_ac_CheckForDisplayChequeNo]
@FinancialAcID int
as
--declare @FinancialAcID int=2
declare @ischeque bit

if((select FinancialSysID from Ac_FinancialAc where FinancialAcID=@FinancialAcID)=4)
begin
set @ischeque=1
select @ischeque as ischeque
end
else
begin
set @ischeque=0
select @ischeque as ischeque
end
--***************sp_12*************



GO
