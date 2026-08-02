SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_SearchFormValue] 
 @FormID INT,
 @FIDs NVARCHAR(250)=null, 
 @FieldIDs NVARCHAR(250), 
 @SearchText varchar(100)=null,
 @CultureCode NVARCHAR(250), 
 @UserModuleID INT,
 @PortalID INT
AS
BEGIN
 DECLARE @FieldValue NVARCHAR(MAX)
SET NOCOUNT ON;
 IF @SearchText IS NOT NULL AND CAST(@FIDs AS INT) = 0 
  BEGIN 
   SELECT F.FormID,F.FormHtml,F.UserModuleID,FF.FieldID,FF.FieldName,FF.ControlType,FF.ControlOrder, FFV.FormSubmittedID,FFV.FormFieldValueID
   ,FFV.FieldSubName,FFV.FieldSubValues 
   FROM Form F RIGHT JOIN FormFields FF ON F.FormID=FF.FormID INNER JOIN FormFieldValue FFV ON FF.FieldID=FFV.FieldID
   WHERE F.FormID=@FormID AND FF.FieldID IN(SELECT items FROM dbo.split(@FieldIDs,',')) AND F.CultureCode=@CultureCode AND F.UserModuleID=@UserModuleID 
   AND FFV.FormSubmittedID=CAST(@SearchText AS INT) AND FFV.PortalID=@PortalID 
   ORDER BY FormSubmittedID,FieldID 
  END
 ELSE IF @SearchText IS NOT NULL AND @FIDs IS NOT NULL
  BEGIN    
   SELECT F.FormID,F.FormHtml,F.UserModuleID,FF.FieldID,FF.FieldName,FF.ControlType,FF.ControlOrder, FFV.FormSubmittedID,FFV.FormFieldValueID,
   FFV.FieldSubName,FFV.FieldSubValues 
   FROM Form F RIGHT JOIN FormFields FF ON F.FormID=FF.FormID INNER JOIN FormFieldValue FFV ON FF.FieldID=FFV.FieldID
   WHERE F.FormID=@FormID AND FF.FieldID IN(SELECT items FROM dbo.split(@FieldIDs,','))  AND F.CultureCode=@CultureCode AND F.UserModuleID=@UserModuleID 
   AND FFV.PortalID=@PortalID AND
   FFV.FormSubmittedID  IN(SELECT DISTINCT(FormSubmittedID) from formfieldvalue WHERE fieldID IN (SELECT items FROM dbo.split(@FIDs,',')) 
   AND LTRIM(FieldSubValues) like '%'+@SearchText+'%')
   ORDER BY FormSubmittedID,FieldID 
  END
 ELSE IF @FIDs IS NULL AND @SearchText IS NOT NULL
  BEGIN 
   SELECT F.FormID,F.FormHtml,F.UserModuleID,FF.FieldID,FF.FieldName,FF.ControlType,FF.ControlOrder, FFV.FormSubmittedID,FFV.FormFieldValueID
   ,FFV.FieldSubName,FFV.FieldSubValues 
   FROM Form F RIGHT JOIN FormFields FF ON F.FormID=FF.FormID INNER JOIN FormFieldValue FFV ON FF.FieldID=FFV.FieldID
   WHERE F.FormID=@FormID AND FF.FieldID IN(SELECT items FROM dbo.split(@FieldIDs,',')) AND F.CultureCode=@CultureCode AND F.UserModuleID=@UserModuleID 
   AND FFV.PortalID=@PortalID AND
   FFV.FormSubmittedID IN (SELECT DISTINCT(FormSubmittedID) from formfieldvalue WHERE FieldSubValues like '%'+@SearchText+'%') 
   ORDER BY FormSubmittedID,FieldID
  END 
 ELSE 
  BEGIN
   SELECT F.FormID,F.FormHtml,F.UserModuleID,FF.FieldID,FF.FieldName,FF.ControlType,FF.ControlOrder, FFV.FormSubmittedID,FFV.FormFieldValueID,
   FFV.FieldSubName,FFV.FieldSubValues 
   FROM Form F RIGHT JOIN FormFields FF ON F.FormID=FF.FormID INNER JOIN FormFieldValue FFV ON FF.FieldID=FFV.FieldID
   WHERE F.FormID=@FormID AND FF.FieldID IN(SELECT items FROM dbo.split(@FieldIDs,',')) AND F.CultureCode=@CultureCode AND F.UserModuleID=@UserModuleID
    AND FFV.PortalID=@PortalID
   ORDER BY FormSubmittedID,FieldID
  END 
END





GO
