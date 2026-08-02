SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_LanguageGet]
AS
BEGIN
SELECT LanguageID,CultureCode,CultureName,FallbackCulture  FROM dbo.Languages;
END;





GO
