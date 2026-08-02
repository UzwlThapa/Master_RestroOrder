SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[USP_RO_DELETECARDPROVIDER]
@ProviderID int
as
begin
delete from RO_CardProvider where ProviderID = @ProviderID
end






GO
