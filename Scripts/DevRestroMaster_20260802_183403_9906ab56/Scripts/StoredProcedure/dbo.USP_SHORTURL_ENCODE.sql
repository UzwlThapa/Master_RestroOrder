SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:  <Author,,Name>
-- Create date: <Create Date,,>
-- Description: <Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[USP_SHORTURL_ENCODE]
 -- Add the parameters for the stored procedure here
 @Url NVARCHAR(1000)
 ,@Code NVARCHAR(8)
AS
BEGIN
 -- SET NOCOUNT ON added to prevent extra result sets from
 -- interfering with SELECT statements.
 SET NOCOUNT ON;

 IF (
   EXISTS (
    SELECT ShortUrlKey
    FROM ShortUrl
    WHERE ShortUrlValue = @Url
    )
   )
 BEGIN
  SELECT @Code = ShortUrlKey
  FROM ShortUrl
  WHERE ShortUrlValue = @Url

  SELECT @Code
 END
 ELSE
 BEGIN
  IF (
    EXISTS (
     SELECT ShortUrlKey
     FROM ShortUrl
     WHERE ShortUrlKey = @Code
     )
    )
  BEGIN
   SELECT @Code = '-1'
    --SELECT @Code = coalesce(@Code, '') + n
    --FROM (
    -- SELECT TOP 8 CHAR(number) n
    -- FROM master..spt_values
    -- WHERE type = 'P'
    --  AND (
    --   number BETWEEN ascii(0)
    --    AND ascii(9)
    --   OR number BETWEEN ascii('A')
    --    AND ascii('Z')
    --   OR number BETWEEN ascii('a')
    --    AND ascii('z')
    --   )
    -- ORDER BY newid()
    -- ) a
  END
  ELSE
  BEGIN
   INSERT INTO dbo.ShortUrl (
    ShortUrlKey
    ,ShortUrlValue
    )
   VALUES (
    @Code
    ,@Url
    )
  END

  SELECT @Code
 END
END





GO
