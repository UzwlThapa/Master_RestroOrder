SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--CREATED BY: DINESH HONA
--CREATED DATE: 2010-03-12
--Modified BY: Dinesh Hona, Milson Munakami
--Modified DAte: 2010-06-27, 2011-01-09
-- [dbo].[sp_PackagesGetByPortalID] 1, ''

CREATE PROCEDURE [dbo].[sp_PackagesGetByPortalID] --1,''
 @PortalID [int],
 @SearchText [nvarchar](4000)
WITH EXECUTE AS CALLER
AS

--Added by shree
declare @tmpResult table
(
    [PackageID] [int] ,
 [PortalID] [int] ,
 [ModuleID] [int] ,
 [Name] [nvarchar](128),
 [FriendlyName] [nvarchar](250),
 [Description] [nvarchar](2000),
 [PackageType] [nvarchar](100) ,
 [Version] [nvarchar](50) ,
 [License] [ntext] ,
 [Manifest] [ntext],
 [Owner] [nvarchar](100),
 [Organization] [nvarchar](100),
 [Url] [nvarchar](250) ,
 [Email] [nvarchar](100),
 [ReleaseNotes] [ntext] ,
 [IsSystemPackage] [bit],
 [IsActive] [bit] ,
 [IsDeleted] [bit],
 [IsModified] [bit],
 [AddedOn] [datetime],
 [UpdatedOn] [datetime],
 [DeletedOn] [datetime],
 [AddedBy] [nvarchar](256),
 [UpdatedBy] [nvarchar](256),
 [DeletedBy] [nvarchar](256),
 [InUse] [int],
 [IsAdmin] [int]
)
--end by shree
INSERT INTO @tmpResult
SELECT 
 [dbo].[Packages].[PackageID],
 [dbo].[Packages].[PortalID],
 [dbo].[Packages].[ModuleID],
 [dbo].[Packages].[Name],
 [dbo].[Packages].[FriendlyName],
 [dbo].[Packages].[Description],
 [dbo].[Packages].[PackageType],
 [dbo].[Packages].[Version],
 [dbo].[Packages].[License],
 [dbo].[Packages].[Manifest],
 [dbo].[Packages].[Owner],
 [dbo].[Packages].[Organization],
 [dbo].[Packages].[Url],
 [dbo].[Packages].[Email],
 [dbo].[Packages].[ReleaseNotes],
 [dbo].[Packages].[IsSystemPackage],
 [dbo].[Packages].[IsActive],
 [dbo].[Packages].[IsDeleted],
 [dbo].[Packages].[IsModified],
 [dbo].[Packages].[AddedOn],
 [dbo].[Packages].[UpdatedOn],
 [dbo].[Packages].[DeletedOn],
 [dbo].[Packages].[AddedBy],
 [dbo].[Packages].[UpdatedBy],
 [dbo].[Packages].[DeletedBy],
 0 AS [InUse],
 [dbo].Modules.IsAdmin --INTO #tmpResult
FROM [dbo].[Packages]
INNER JOIN [dbo].PortalModules ON [dbo].[Packages].ModuleID=[dbo].PortalModules.ModuleID
INNER JOIN [dbo].Modules ON [dbo].Modules.ModuleID=[dbo].[Packages].ModuleID
WHERE 1=2

IF(len(@SearchText)>0)
BEGIN
declare @tbltemp table
(
RowNum int identity(1,1),
SearchText nvarchar(500)
)
insert into @tbltemp(SearchText)
SELECT rtrim(ltrim(items)) FROM split(@SearchText,' ')
DECLARE @KeyCount int, @ValueCount int,@counter int
SELECT @KeyCount=count(RowNum) from @tbltemp


set @counter=1
WHILE(@counter<=@KeyCount or @counter=1)
  BEGIN
 declare @key nvarchar(500)
select @key=SearchText from @tbltemp where RowNum=@counter
print @key
INSERT INTO @tmpResult
SELECT 
 [dbo].[Packages].[PackageID],
 [dbo].[Packages].[PortalID],
 [dbo].[Packages].[ModuleID],
 [dbo].[Packages].[Name],
 [dbo].[Packages].[FriendlyName],
 [dbo].[Packages].[Description],
 [dbo].[Packages].[PackageType],
 [dbo].[Packages].[Version],
 [dbo].[Packages].[License],
 [dbo].[Packages].[Manifest],
 [dbo].[Packages].[Owner],
 [dbo].[Packages].[Organization],
 [dbo].[Packages].[Url],
 [dbo].[Packages].[Email],
 [dbo].[Packages].[ReleaseNotes],
 [dbo].[Packages].[IsSystemPackage],
 [dbo].[Packages].[IsActive],
 [dbo].[Packages].[IsDeleted],
 [dbo].[Packages].[IsModified],
 [dbo].[Packages].[AddedOn],
 [dbo].[Packages].[UpdatedOn],
 [dbo].[Packages].[DeletedOn],
 [dbo].[Packages].[AddedBy],
 [dbo].[Packages].[UpdatedBy],
 [dbo].[Packages].[DeletedBy],
 (SELECT
  CASE 
  WHEN [dbo].[UserModules].ModuleDefID IS NULL THEN 0 ELSE 1
  END
  FROM [dbo].[ModuleDefinitions] 
  LEFT JOIN [dbo].[UserModules] ON [dbo].[UserModules].ModuleDefID = [dbo].ModuleDefinitions.ModuleDefID
  WHERE [dbo].ModuleDefinitions.ModuleID = [dbo].[Packages].ModuleID
  GROUP BY [dbo].[UserModules].ModuleDefID
 )
  AS [InUse],
 [dbo].Modules.IsAdmin
FROM [dbo].[Packages]
INNER JOIN [dbo].PortalModules ON [dbo].[Packages].ModuleID=[dbo].PortalModules.ModuleID
INNER JOIN [dbo].Modules ON [dbo].Modules.ModuleID=[dbo].[Packages].ModuleID
WHERE
 --([dbo].[Packages].PortalID = @PortalID OR @PortalID IS NULL OR [dbo].[Packages].PortalID IS NULL) AND 
([dbo].PortalModules.PortalID = @PortalID )AND
([dbo].[Packages].IsDeleted=0 OR [dbo].[Packages].IsDeleted IS NULL) AND 
[dbo].[Packages].[FriendlyName] LIKE @key+'%'
ORDER BY PackageType ASC, [FriendlyName] ASC
set @counter=@counter+1
  END

END
ELSE
BEGIN

INSERT INTO @tmpResult
SELECT 
 [dbo].[Packages].[PackageID],
 [dbo].[Packages].[PortalID],
 [dbo].[Packages].[ModuleID],
 [dbo].[Packages].[Name],
 [dbo].[Packages].[FriendlyName],
 [dbo].[Packages].[Description],
 [dbo].[Packages].[PackageType],
 [dbo].[Packages].[Version],
 [dbo].[Packages].[License],
 [dbo].[Packages].[Manifest],
 [dbo].[Packages].[Owner],
 [dbo].[Packages].[Organization],
 [dbo].[Packages].[Url],
 [dbo].[Packages].[Email],
 [dbo].[Packages].[ReleaseNotes],
 [dbo].[Packages].[IsSystemPackage],
 [dbo].[Packages].[IsActive],
 [dbo].[Packages].[IsDeleted],
 [dbo].[Packages].[IsModified],
 [dbo].[Packages].[AddedOn],
 [dbo].[Packages].[UpdatedOn],
 [dbo].[Packages].[DeletedOn],
 [dbo].[Packages].[AddedBy],
 [dbo].[Packages].[UpdatedBy],
 [dbo].[Packages].[DeletedBy],
 (SELECT
  CASE 
  WHEN [dbo].[UserModules].ModuleDefID IS NULL THEN 0 ELSE 1
  END
  FROM [dbo].[ModuleDefinitions] 
  LEFT JOIN [dbo].[UserModules] ON [dbo].[UserModules].ModuleDefID = [dbo].ModuleDefinitions.ModuleDefID
  WHERE [dbo].ModuleDefinitions.ModuleID = [dbo].[Packages].ModuleID
  GROUP BY [dbo].[UserModules].ModuleDefID
 )
  AS [InUse],
 [dbo].Modules.IsAdmin
FROM [dbo].[Packages]
INNER JOIN [dbo].PortalModules ON [dbo].[Packages].ModuleID=[dbo].PortalModules.ModuleID
INNER JOIN [dbo].Modules ON [dbo].Modules.ModuleID=[dbo].[Packages].ModuleID
WHERE
 --([dbo].[Packages].PortalID = @PortalID OR @PortalID IS NULL OR [dbo].[Packages].PortalID IS NULL) AND 
([dbo].PortalModules.PortalID = @PortalID )AND
([dbo].[Packages].IsDeleted=0 OR [dbo].[Packages].IsDeleted IS NULL) AND 
[dbo].[Packages].[FriendlyName] LIKE @SearchText+'%'
ORDER BY PackageType ASC, [FriendlyName] ASC
END

SELECT * FROM @tmpResult





GO
