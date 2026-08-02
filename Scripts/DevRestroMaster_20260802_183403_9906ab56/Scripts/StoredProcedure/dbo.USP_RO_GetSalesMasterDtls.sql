SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_RO_GetSalesMasterDtls] 
@salesMasterId int 
as
begin
 select salesMasterId, isnull(totaldiscount,0) as totaldiscount, 
 isnull(CusName,'') as CusName, isnull(PhoneNumber,'') as PhoneNumber 
 from RO_SalesMaster with(nolock)
 where salesMasterId = @salesMasterId
end

GO
