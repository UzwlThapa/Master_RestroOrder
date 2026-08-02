SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--DROP proc [dbo].[USP_RO_GETCARDPROVIDER]
CREATE PROCEDURE [dbo].[USP_RO_GETCARDPROVIDER]
as
begin
select * from RO_CardProvider order by ProviderName
end






GO
