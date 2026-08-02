SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--CREATED DATE: 2010-07-29
CREATE PROCEDURE [dbo].[usp_PagePortalGetByCustomPrefix] 
 @prefix NVARCHAR(10),
 @IsActive BIT,
 @IsDeleted BIT,
 @PortalID INT,
 @UserName NVARCHAR(256),
 @IsVisible BIT,
 @IsRequiredPage BIT
WITH EXECUTE AS CALLER
AS
BEGIN
SELECT * FROM Pages WHERE (PortalID=@PortalID OR PortalID=-1) AND IsDeleted=0
END





GO
