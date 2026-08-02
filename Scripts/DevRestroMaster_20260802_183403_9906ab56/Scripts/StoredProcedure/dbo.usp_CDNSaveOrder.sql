SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_CDNSaveOrder] 
@URLID INT,
@URLOrder INT,
@PortalID INT
AS
BEGIN

 UPDATE [dbo].[CDN]
 SET 
 URLOrder = @URLOrder
 WHERE URLID = @URLID AND PortalID = @PortalID
END


--1 http://ajax.googleapis.com/ajax/libs/jquery/1/jquery.min.js True 0 1
--10 http://code.jquery.com/ui/1.9.2/jquery-ui.min.js True 1 1





GO
