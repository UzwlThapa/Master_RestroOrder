SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_loc_EnableLanguage]
(
 @PortalID INT,
 @LanguageID INT,
 @AddedBy VARCHAR(256),
 @IsEnabled BIT,
 @IsPublished BIT
)
AS
BEGIN
DECLARE @EXISTS INT
SELECT @EXISTS=COUNT(*) FROM PortalLanguages 
WHERE PortalID=@PortalID AND LanguageID=@LanguageID
IF @EXISTS>0
  DELETE FROM PortalLanguages
  WHERE PortalID=@PortalID AND LanguageID=@LanguageID;
ELSE 
 INSERT INTO PortalLanguages
 (
  PortalID,LanguageID,AddedOn,AddedBy 
 )
 VALUES
 (
  @PortalID,@LanguageID,GETDATE(),@AddedBy
 )
END;





GO
