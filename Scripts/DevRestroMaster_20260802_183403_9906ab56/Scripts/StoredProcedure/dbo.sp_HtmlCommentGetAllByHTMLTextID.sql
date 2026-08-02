SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_HtmlCommentGetAllByHTMLTextID]
 @PortalID INT,
 @HTMLTextID INT
 
WITH EXECUTE AS CALLER
AS
BEGIN


 SELECT
 [HTMLCommentID],
 [HTMLTextID],
 [Comment],
 [IsApproved],
 [IsActive],
 [IsDeleted],
 [IsModified],
 [AddedOn],
 [UpdatedOn],
 [DeletedOn],
 [ApprovedOn],
 [PortalID],
 [AddedBy],
 [UpdatedBy],
 [DeletedBy],
 [ApprovedBy]
FROM dbo.[HtmlComment]
WHERE
 [PortalID]=@PortalID AND [HTMLTextID]=@HTMLTextID AND (IsDeleted=0 OR IsDeleted IS NULL)
END
/****** Object:  StoredProcedure [dbo].[sp_HtmlCommentGetByHTMLCommentID]    Script Date: 12/02/2012 13:49:51 ******/
SET ANSI_NULLS ON





GO
