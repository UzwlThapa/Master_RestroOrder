SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_sftemplate_updactive] 
@TemplateName NVARCHAR (50) AS
BEGIN

IF (
 (
  SELECT
   COUNT (*)
  FROM
   sftemplate
 ) > 0
)
BEGIN
 UPDATE sftemplate
SET TemplateName =@TemplateName
END
ELSE

BEGIN
 INSERT INTO sftemplate (TemplateName, IsActive)
VALUES
 (@TemplateName, 1)
END
END





GO
