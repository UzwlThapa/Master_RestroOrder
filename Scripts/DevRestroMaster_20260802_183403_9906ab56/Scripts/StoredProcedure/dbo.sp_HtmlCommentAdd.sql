SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================

-- Create date: 2010-03-30
-- Description: HTML/Text Module -- Comment section
-- ============================================= 
CREATE PROCEDURE [dbo].[sp_HtmlCommentAdd]
 -- Add the parameters for the stored procedure here
   @HTMLCommentID INT OUTPUT
     ,@HTMLTextID INT
           ,@Comment NTEXT
           ,@IsApproved BIT
           ,@IsActive BIT
           ,@AddedOn DATETIME
           ,@PortalID INT
           ,@AddedBy NVARCHAR(256)
AS
BEGIN
 INSERT INTO [dbo].[HtmlComment]
           ([HTMLTextID]
           ,[Comment]
           ,[IsApproved]
           ,[IsActive]           
           ,[AddedOn]
           ,[PortalID]
           ,[AddedBy])
     VALUES
     (@HTMLTextID
           ,@Comment
           ,@IsApproved
           ,@IsActive
           ,@AddedOn
           ,@PortalID
           ,@AddedBy)

SELECT @HTMLCommentID=SCOPE_IDENTITY()

END
/****** Object:  StoredProcedure [dbo].[sp_HtmlCommentDeleteByCommentID]    Script Date: 12/02/2012 13:47:13 ******/
SET ANSI_NULLS ON





GO
