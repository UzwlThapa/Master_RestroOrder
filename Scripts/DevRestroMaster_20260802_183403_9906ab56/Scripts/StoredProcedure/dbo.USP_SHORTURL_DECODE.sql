SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:  <Author,,Name>
-- Create date: <Create Date,,>
-- Description: <Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[USP_SHORTURL_DECODE]
 -- Add the parameters for the stored procedure here
 @Key NVARCHAR(8)
AS
BEGIN
 -- SET NOCOUNT ON added to prevent extra result sets from
 -- interfering with SELECT statements.
 SET NOCOUNT ON;

 IF (
   EXISTS (
    SELECT ShortUrlKey
    FROM ShortUrl
    WHERE ShortUrlKey = @Key
    )
   )
 BEGIN  
  SELECT ShortUrlValue
  FROM ShortUrl
  WHERE ShortUrlKey = @Key
 END
 ELSE
  SELECT 'code does not exist'
END





GO
