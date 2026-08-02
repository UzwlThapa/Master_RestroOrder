SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================

-- Create date: 2010-03-30
-- Description: HTML/Text Module -- Comment section
-- ============================================= 
CREATE PROCEDURE [dbo].[sp_HtmlCommentUpdate]
 -- Add the parameters for the stored procedure here
   @HTMLCommentID INT
   ,@Comment NTEXT
   ,@IsApproved BIT
   ,@IsActive BIT
   ,@IsModified BIT
   ,@UpdatedOn DATETIME
   ,@PortalID INT
   ,@UpdatedBy NVARCHAR(256)
AS
BEGIN
 UPDATE [dbo].[HtmlComment] SET
 [Comment] = @Comment,
 [IsApproved]=@IsApproved,
 [IsActive] = @IsActive,
 [IsModified] = @IsModified,
 [UpdatedOn] = @UpdatedOn,
 [PortalID] = @PortalID,
 [UpdatedBy] = @UpdatedBy
WHERE
 [HTMLCommentID] = @HTMLCommentID
END





GO
