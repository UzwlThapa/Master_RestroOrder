SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_UpdateFormField]
( @FormID INT,
 @FieldID INT,
 @PortalID INT,
 @AddedBy NVARCHAR (256))
  AS
BEGIN
 UPDATE FormFields
SET IsActive = 0,
 IsModified = 1,
 UpdatedBy =@AddedBy,
 UpdatedOn = GETDATE()
WHERE
 [FormID] = @FormID
AND FieldID = @FieldID
AND PortalID =@PortalID
END





GO
