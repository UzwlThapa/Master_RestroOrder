SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_BlogRssContentAdd]
@BlogContent TEXT
AS
BEGIN

 SET NOCOUNT ON;

  BEGIN TRAN
     DELETE FROM dbo.BlogRssContent
     IF(@@error<>0) GOTO ErrorHandler
    
     INSERT INTO dbo.BlogRssContent(BlogContent,UpdatedDate) VALUES(@BlogContent,GETDATE());
     IF(@@error<>0) GOTO ErrorHandler

    COMMIT TRAN
RETURN 0
ERRORHANDLER:
 ROLLBACK TRAN
RETURN 1
    
END





GO
