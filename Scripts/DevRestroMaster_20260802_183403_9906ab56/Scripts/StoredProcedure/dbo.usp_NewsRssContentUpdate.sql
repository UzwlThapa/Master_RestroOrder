SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_NewsRssContentUpdate]
@NewsContent TEXT
AS
BEGIN
 SET NOCOUNT ON;
  BEGIN TRAN
   DELETE FROM 
    dbo.NewsRssContent
   IF(@@ERROR<>0) 
    GOTO ErrorHandler     
   INSERT INTO 
    dbo.NewsRssContent
         (
          NewsContent,
          UpdatedDate
         ) 
        VALUES
         (
          @NewsContent,
          GETDATE()
         )
   IF(@@ERROR<>0) 
    GOTO ErrorHandler
  COMMIT TRAN
  RETURN 0

  ERRORHANDLER:
   ROLLBACK TRAN
  RETURN 1    
END





GO
