SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:  Sushil Sapkota
-- Create date: 22/09/2013
-- Description: Publishing the page
-- =============================================
CREATE PROCEDURE [dbo].[usp_PagePublish] @PageId INT
 ,@IsPublished BIT
AS
BEGIN
 SET NOCOUNT ON;

 UPDATE Pages
 SET IsVisible = @IsPublished
 WHERE PageID = @PageId
END





GO
