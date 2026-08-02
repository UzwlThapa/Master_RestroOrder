SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_MenuMgrGetMenuItem] 
@MenuID INT

AS
BEGIN
 SELECT 
    [mi].[MenuItemID]
    ,[mi].[MenuID]
    ,[mi].[LinkType]
    ,[mi].[PageID]
    ,[mi].[Title]
    ,[mi].[LinkURL]
    ,[mi].[ImageIcon]
    ,[mi].[Caption]
    ,[mi].[HtmlContent]
    ,[mi].[ParentID]
    ,[mi].[MenuLevel]
    ,[mi].[MenuOrder]
    ,[mi].[SubText]
    ,[mi].[IsVisible]
    ,[mi].[IsActive]
    ,[p].[PageID]
    ,[p].[PageOrder]
    ,[p].[PageName]
    ,[p].[IsVisible]
    ,[p].[ParentID]
    ,[p].[Level]
    ,[p].[IconFile]
    ,[p].[DisableLink]
    ,[p].[Title]
    ,[p].[Description]
    ,[p].[KeyWords]
    ,(
     SELECT COUNT(1) 
     FROM   MenuItem m 
     WHERE   m.ParentID=mi.MenuItemID
    ) AS ChildCount 
  
 FROM    [dbo].[MenuItem] mi 
    LEFT JOIN  Pages p ON mi.PageID=p.PageID
 WHERE    mi.MenuID =@MenuID
 ORDER BY   MenuLevel,MenuOrder
END





GO
