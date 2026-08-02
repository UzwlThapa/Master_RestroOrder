SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_DeleteGlobalizedMenubyLanguageId]
@LanguageID int
as
DELETE FROM RO_GlobalizedMenu where LanguageID=@LanguageID

GO
