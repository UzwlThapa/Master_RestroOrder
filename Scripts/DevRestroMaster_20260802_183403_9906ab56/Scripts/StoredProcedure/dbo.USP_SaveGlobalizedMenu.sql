SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_SaveGlobalizedMenu]
@ItemID int
,@LanguageID int
,@Text nvarchar(250)
AS
BEGIN
INSERT INTO RO_GlobalizedMenu
(
ItemID
,LanguageID
,[Text]
)
VALUES
(
@ItemID
,@LanguageID
,@Text
)
END

GO
