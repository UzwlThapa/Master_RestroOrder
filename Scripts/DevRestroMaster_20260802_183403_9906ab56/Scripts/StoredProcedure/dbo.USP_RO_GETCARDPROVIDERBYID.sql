SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[USP_RO_GETCARDPROVIDERBYID]
@ProviderID int
as
begin
select * from RO_CardProvider where ProviderID = @ProviderID
end






GO
