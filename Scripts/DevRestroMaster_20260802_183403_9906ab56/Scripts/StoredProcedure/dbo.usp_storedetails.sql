SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_storedetails]
@itemID int
as
select st.StName
,sis.StoreItemId
,sis.StoreId
,sis.StoreId
,sis.Unit
,sis.Value
,ru.UnitDescription
from StoreItemMinimumStock sis
left join ROI_Store st on st.STId = sis.StoreId 
left join ROI_Unit1 ru on ru.Unit1Id = sis.Unit
where sis.ItemId = @itemID
-----------------------------------------------------------------------------------------------------

GO
