SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[vw_Lists]
AS
SELECT     EntryID, ListName, Value, Text, LEVEL, CurrencyCode, DisplayLocale, DisplayOrder, DefinitionID, ParentID, Description, PortalID, SystemList, Culture, 
                      dbo.GetListParentKey(ParentID, ListName, N'ParentKey', 0) AS ParentKey, dbo.GetListParentKey(ParentID, ListName, N'Parent', 0) AS Parent, 
                      dbo.GetListParentKey(ParentID, ListName, N'ParentList', 0) AS ParentList,
                          (SELECT     MAX(DisplayOrder) AS Expr1
                            FROM          dbo.Lists
                            WHERE      (ListName = L.ListName) AND (ParentID = L.ParentID)) AS MaxSortOrder,
                          (SELECT     COUNT(EntryID) AS Expr1
                            FROM          dbo.Lists AS Lists_1
                            WHERE      (ListName = L.ListName) AND (ParentID = L.ParentID)) AS EntryCount,
                          (SELECT     COUNT(DISTINCT ParentID) AS Expr1
                            FROM          dbo.Lists AS Lists_2
                            WHERE      (ParentID = L.EntryID)) AS HasChildren, IsActive, AddedBy, AddedOn, UpdatedBy, UpdatedOn
FROM         dbo.Lists AS L





GO
