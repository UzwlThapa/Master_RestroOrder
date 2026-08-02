SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_DeleteMinimumSTock]
@ItemId int
as
begin
 delete from StoreItemMinimumStock where ItemId=@ItemId
end
-----------------------------------------------------------------------------------------------------

GO
