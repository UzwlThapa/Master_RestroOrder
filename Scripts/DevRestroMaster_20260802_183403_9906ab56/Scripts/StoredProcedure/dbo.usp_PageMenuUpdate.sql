SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_PageMenuUpdate]
@PageID INT,
@PortalID INT,
@IsAdmin BIT,
@IsFooter BIT
AS
BEGIN
SET NOCOUNT ON;
 UPDATE [dbo].[PageMenu]
 SET IsAdmin=@IsAdmin,IsFooter=@IsFooter
 WHERE
 PageID=@PageID
END





GO
