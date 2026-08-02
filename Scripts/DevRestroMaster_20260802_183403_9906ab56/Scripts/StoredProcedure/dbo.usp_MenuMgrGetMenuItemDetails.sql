SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_MenuMgrGetMenuItemDetails]
(
 @MenuItemID INT
)
AS
BEGIN
 SELECT [MenuItemID]
    ,[MenuID]
    ,[LinkType]
    ,[PageID]
    ,[Title]
    ,[LinkURL]
    ,[ImageIcon]
    ,[Caption]
    ,[HtmlContent]
    ,[ParentID]
    ,[MenuLevel]
    ,[MenuOrder]
    ,[SubText]
    ,[IsActive]
    ,[IsVisible]
    ,[IsDeleted]
    ,[IsModified]
    ,[AddedOn]
    ,[UpdatedOn]
    ,[DeletedOn]
    ,[PortalID]
    ,[AddedBy]
    ,[UpdatedBy]
    ,[DeletedBy]
   FROM 
  [dbo].[MenuItem]
   WHERE 
  [MenuItemID]=@MenuItemID
END





GO
