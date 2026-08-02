SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_PagesGetByPageID] 
  @PageID int 
AS


DECLARE @str VARCHAR(100)
DECLARE @MenuPages nvarchar(250)
DECLARE @caption nvarchar(250)
set @caption = (select top 1 caption from MenuItem where PageID=@PageID)
select @str=COALESCE(@str+'/', '') + cast(MenuID as varchar(20))  from MenuItem where PageID=@PageID
select @MenuPages=ISNULL(@str,0)


SELECT
 [PageID],
 [PageOrder],
 [PageName],
 [IsVisible],
 [ParentID],
 [Level],
 [IconFile],
 [DisableLink],
 [Title],
 [Description],
 [KeyWords],
 [Url],
 [TabPath],
 [StartDate],
 [EndDate],
 [RefreshInterval],
 [PageHeadText],
 [IsSecure],
 [IsActive],
 [IsDeleted],
 [IsModified],
 [AddedOn],
 [UpdatedOn],
 [DeletedOn],
 [PortalID],
 [AddedBy],
 [UpdatedBy],
 [DeletedBy],
 [SEOName],
 [IsShowInFooter],
 [IsRequiredPage],
 @MenuPages AS MenuPages,
 @caption AS caption
 
FROM dbo.Pages
WHERE
 [PageID] = @PageID





GO
