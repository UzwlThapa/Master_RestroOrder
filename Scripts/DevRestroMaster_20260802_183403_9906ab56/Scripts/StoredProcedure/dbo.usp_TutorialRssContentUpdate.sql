SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_TutorialRssContentUpdate]
(@TutorialContent TEXT)
AS
BEGIN

 SET NOCOUNT ON;

  BEGIN TRAN
     DELETE FROM dbo.TutorialRssContent
     IF(@@error<>0) goto ErrorHandler
    
     INSERT INTO dbo.TutorialRssContent(TutorialContent,UpdatedDate) VALUES(@TutorialContent,GETDATE());
     if(@@error<>0) goto ErrorHandler

    COMMIT TRAN
RETURN 0
ERRORHANDLER:
 ROLLBACK TRAN 
RETURN 1
    
END





GO
