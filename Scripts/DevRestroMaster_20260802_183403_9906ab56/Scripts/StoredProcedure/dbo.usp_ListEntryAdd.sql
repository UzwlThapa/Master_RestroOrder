SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_ListEntryAdd]

 @ListName NVARCHAR(50), 
 @Value NVARCHAR(100), 
 @Text NVARCHAR(150),
 @ParentID INT,
 @Level INT,
 @CurrencyCode NVARCHAR(50),
 @DisplayLocale NVARCHAR(50), 
 @EnableDisplayOrder BIT,
 @DefinitionID INT, 
 @Description NVARCHAR(500),
 @PortalID INT,  
 @IsActive BIT,
 @AddedBy NVARCHAR(256),
 @Culture NVARCHAR(256),
 @ListID INT OUTPUT
 

AS
 DECLARE @DisplayOrder INT

 IF @EnableDisplayOrder = 1
  SET @DisplayOrder = ISNULL((SELECT MAX ([DisplayOrder]) FROM dbo.Lists 
     WHERE [ListName] = @ListName AND Culture=@Culture ), 0) + 1
 ELSE
  SET @DisplayOrder = 0
 -- Check if this entry exists
 If EXISTS (SELECT [EntryID] FROM dbo.Lists WHERE [ListName] = @ListName 
    AND [Value] = @Value AND [Text] = @Text 
 AND [ParentID] = @ParentID AND Culture=@Culture)
 BEGIN
  SELECT @ListID=0
  RETURN 
 END
 ELSE
 BEGIN
 INSERT INTO dbo.Lists 
  (
    [ListName],
  [Value],
  [Text],
  [ParentID],
  [Level],
  [CurrencyCode],
  [DisplayLocale],
  [DisplayOrder],
  [DefinitionID],  
  [Description],
  [PortalID],  
  [IsActive],
  [AddedBy],
  [AddedOn],
  [Culture]
  
  )
 VALUES (
  @ListName,
  @Value,
  @Text,
  @ParentID,
  @Level,
  @CurrencyCode,
  @DisplayLocale, 
  @DisplayOrder,  
  @DefinitionID,  
  @Description,
  @PortalID,  
  @IsActive,
    @AddedBy,
    GETDATE(),
    @Culture 
  )

 SELECT @ListID=SCOPE_IDENTITY()
END





GO
