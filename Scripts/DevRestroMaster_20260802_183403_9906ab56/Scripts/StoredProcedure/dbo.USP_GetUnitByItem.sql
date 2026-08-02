SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--[USP_GetUnitByItem] 'Appetizers'

CREATE PROCEDURE [dbo].[USP_GetUnitByItem]
@ItemNames nvarchar(100)
as
begin
CREATE  table #Temp (
ItemID int,
UnitName nvarchar(100),
--MunitID int,
UnitId int,
ItemName nvarchar(100),
IsExpirable bit
)

declare @munitID1 int
declare @UnitId int
declare @ItemName nvarchar(100)
declare @UnitName nvarchar(100)
declare @ITId int
declare @isExpirable bit


select @munitID1=MUnitId from ROI_ItemDetails m
 inner join dbo.ROI_ITEMMain i  on m.ITId = i.ITId
 where ITName = @ItemNames

 
 select @ITId = m.ITId from ROI_ItemDetails m
 inner join dbo.ROI_ITEMMain i  on m.ITId = i.ITId
 where ITName = @ItemNames

  select @ItemName =ITName from ROI_ItemDetails m
 inner join dbo.ROI_ITEMMain i  on m.ITId = i.ITId
 where ITName = @ItemNames

--declare @munitID1 int
 select @munitID1=MUnitId from ROI_ItemDetails m
 inner join dbo.ROI_ITEMMain i  on m.ITId = i.ITId
 where ITName = @ItemNames

select @UnitName= UnitName  from FGetUnitOf(@munitID1)
select @UnitId = UnitId  from FGetUnitOf(@munitID1)

select @isExpirable=isExpirable from ROI_ItemDetails m
 inner join dbo.ROI_ITEMMain i  on m.ITId = i.ITId
 where ITName = @ItemNames

Insert Into #Temp (ItemID,UnitName,UnitId,ItemName,IsExpirable) values (@ITId,@UnitName, @UnitId,@ItemName,@isExpirable)
select * from #Temp
end





GO
