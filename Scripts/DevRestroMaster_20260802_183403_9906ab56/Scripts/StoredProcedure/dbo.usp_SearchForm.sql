SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_SearchForm] 
@CultureCode NVARCHAR(250),
@UserModuleID INT,
@SearchText NVARCHAR(100),
@PortalID INT
AS
BEGIN
 SELECT FormID,LTRIM(Title) AS Title,AddedOn FROM Form 
 WHERE [PortalID] =@PortalID AND CultureCode=@CultureCode AND UserModuleID=@UserModuleID  AND (ISDELETED= 0 OR ISDELETED is NULL) 
 AND LTRIM(Title) LIKE @SearchText+'%'
 ORDER BY Title ASC
END





GO
