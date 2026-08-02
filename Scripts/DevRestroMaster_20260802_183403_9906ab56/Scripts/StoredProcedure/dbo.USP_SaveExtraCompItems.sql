SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE  [dbo].[USP_SaveExtraCompItems]
@CompMasterID int
,@ItemID int
,@ExtraItemID int
,@ExtraItem nvarchar(256)
,@Quantity int
,@ExtraPrice decimal(18, 2)
as 
begin
insert into Comp_ExtraItem
(CompMasterID
,ItemID
,ExtraItemID
,ExtraItem
,Quantity
,ExtraPrice
)
values
(
@CompMasterID
,@ItemID
,@ExtraItemID
,@ExtraItem
,@Quantity 
,@ExtraPrice
)
end

GO
