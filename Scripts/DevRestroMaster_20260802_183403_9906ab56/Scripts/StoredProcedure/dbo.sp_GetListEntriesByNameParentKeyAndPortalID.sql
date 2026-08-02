SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_GetListEntriesByNameParentKeyAndPortalID] 
@ListName nvarchar(50), 
@ParentKey nvarchar(150), 
@PortalID int, 
@Culture nvarchar(256) 
AS BEGIN
SELECT EntryID,ListName,Value,[Text],[LEVEL] as [Level],CurrencyCode,DisplayLocale,DisplayOrder,DefinitionID,ParentID,[Description],PortalID,SystemList,Culture, ParentKey,Parent,ParentList,MaxSortOrder,EntryCount,HasChildren,IsActive,AddedBy,AddedOn,UpdatedBy,UpdatedOn 
FROM dbo.vw_Lists 
WHERE (ListName = @ListName ) AND (ParentKey = @ParentKey ) AND (PortalID = @PortalID OR @PortalID IS NULL or SystemList=1) AND Culture=@Culture 
ORDER BY DisplayOrder
END





GO
