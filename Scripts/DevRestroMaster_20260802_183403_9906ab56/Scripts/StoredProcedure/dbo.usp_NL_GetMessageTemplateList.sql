SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--CREATED BY: DINESH HONA
--CREATED DATE: 2010-04-09
--Modified DATE: 2010-04-25
CREATE PROCEDURE [dbo].[usp_NL_GetMessageTemplateList]
    @Current INT,
    @Pagesize INT,
 @IsActive [bit],
 @IsDeleted [bit],
 @PortalID [int],
 @UserName NVARCHAR(256),
 @CurrentCulture NVARCHAR(256)
WITH EXECUTE AS CALLER
AS
DECLARE @RowTotal INT
SELECT @RowTotal=COUNT(*)
FROM dbo.MessageTemplate WHERE (IsDeleted=0 OR IsDeleted IS NULL)  AND PortalID=@PortalID AND IsActive=@IsActive;
 WITH MessageTemplateList AS
 (SELECT @RowTotal as MessageTokenID,*,ROW_NUMBER() OVER(ORDER BY (MessageTemplateID)) AS RowNumber
 FROM
 ( 
SELECT
 [MessageTemplateID],
 [MessageTemplateTypeID],
 [Subject],
 [Body],
 [MailFrom],
 [IsActive],
 [IsDeleted],
 [IsModified],
 [AddedOn],
 [UpdatedOn],
 [DeletedOn],
 [PortalID],
 [AddedBy],
 [UpdatedBy],
 [DeletedBy]
FROM [dbo].[MessageTemplate]
WHERE (IsDeleted=0 OR IsDeleted IS NULL) AND PortalID=@PortalID AND IsActive=@IsActive

 )DataTable
  )

  SELECT * FROM MessageTemplateList WHERE RowNumber>=(@Current-1)*@PageSize+1
       AND RowNumber<=(@pageSize*@Current)





GO
