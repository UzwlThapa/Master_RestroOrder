SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_FormValueDelete] 
 @FormID int,
 @FormSubmittedID int,
 @UserModuleID int,
 @PortalID int 
AS
BEGIN
 DELETE  FormFieldValue WHERE FormSubmittedID IN
  (SELECT FFV.FormSubmittedID 
  FROM Form F inner join FormFields FF ON F.FormID=FF.FormID inner join FormFieldValue FFV ON FF.FieldID=FFV.FieldID
  WHERE F.FormID=@FormID and F.UserModuleID=@UserModuleID and F.PortalID=@PortalID and FFV.FormSubmittedID=@FormSubmittedID)
END





GO
