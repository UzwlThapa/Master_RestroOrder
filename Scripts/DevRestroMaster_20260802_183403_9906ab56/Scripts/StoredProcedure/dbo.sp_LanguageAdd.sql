SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_LanguageAdd]

 @CultureCode      NVARCHAR(50),
 @CultureName            NVARCHAR(200),
 @FallbackCulture        NVARCHAR(50),
 @FallbackCultureCode NVARCHAR(50),
 @CreatedByUserID INT

AS
IF NOT EXISTS(SELECT CultureCode FROM dbo.Languages WHERE CultureCode=@CultureCode)
BEGIN
 INSERT INTO dbo.Languages (
  CultureCode,
  CultureName,
  FallbackCulture,
  FallbackCultureCode,
  [CreatedByUserID],
  [CreatedOnDate],
  [LastModifiedByUserID],
  [LastModifiedOnDate]
 )
 VALUES (
  @CultureCode,
  @CultureName,
  @FallbackCulture,
  @FallbackCultureCode,
  @CreatedByUserID,
    GETDATE(),
    @CreatedByUserID,
    GETDATE()
 )
 SELECT SCOPE_IDENTITY()
END





GO
