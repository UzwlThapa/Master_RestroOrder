SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_loc_PortalLanguagesGet]
(
@PortalID INT
)
AS
BEGIN
SELECT pl.PortalID,pl.LanguageID,l.CultureCode,l.CultureName,l.LanguageID 
FROM portallanguages pl
INNER JOIN Languages l ON pl.LanguageID=l.LanguageID
WHERE pl.PortalID=@PortalID OR l.CultureCode='en-US'
END;





GO
