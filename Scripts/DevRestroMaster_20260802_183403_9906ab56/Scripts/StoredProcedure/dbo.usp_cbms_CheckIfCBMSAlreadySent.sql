SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_cbms_CheckIfCBMSAlreadySent] 
@salesMasterId int
as
begin
	if exists(select LogID from CBMS_BillPostLog where SalesMasterId=@salesMasterId)
	begin
	select cast(1 as bit)
	end
	else
	begin
	select cast(0 as bit)
	end
end

GO
