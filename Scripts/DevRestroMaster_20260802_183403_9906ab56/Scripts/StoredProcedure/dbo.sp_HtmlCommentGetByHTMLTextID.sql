SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:  Milson Munakami
-- Create date: 2010-03-30
-- Description: HTML/Text Module -- Comment section
-- ============================================= 
CREATE PROCEDURE [dbo].[sp_HtmlCommentGetByHTMLTextID] 
 -- Add the parameters for the stored procedure here
 @PortalID int,
 @HTMLTextID int
AS
BEGIN
 SELECT
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
 [PortalID]=@PortalID AND [HTMLTextID]=@HTMLTextID
END





GO
