SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_ListEntryDeleteByID]

@EntryId   INT,
@DeleteChild BIT,
@Culture nvarchar(256),
@IsExist BIT OUTPUT

AS

DECLARE @ListName NVARCHAR(256)
SELECT @ListName=ListName FROM dbo.Lists WHERE EntryID=@EntryID 

DELETE
FROM dbo.Lists
WHERE  [EntryID] = @EntryID AND Culture=@Culture

IF(EXISTS(SELECT * FROM dbo.Lists WHERE ListName=@ListName))SET @IsExist=1

ELSE SET @IsExist=0
 

IF @DeleteChild = 1
BEGIN
 DELETE 
 FROM dbo.Lists
 WHERE [ParentID] = @EntryID AND Culture=@Culture
END





GO
