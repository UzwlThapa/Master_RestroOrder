SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_LanguageDelete]
 @code  NVARCHAR(200)
AS
    DELETE
     FROM dbo.Languages
     WHERE   CultureCode = @code





GO
