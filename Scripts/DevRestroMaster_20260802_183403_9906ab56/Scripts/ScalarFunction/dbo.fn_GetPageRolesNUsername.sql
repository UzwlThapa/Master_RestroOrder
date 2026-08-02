SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:  DINESH HONA
-- Create date: 2010-03-15
-- Description: <Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[fn_GetPageRolesNUsername]
(
@PageID int
)
RETURNS nvarchar(1000)
AS
BEGIN
DECLARE @ROLEs nvarchar(1000)
SET @ROLEs=''
SELECT @ROLEs=@ROLEs+','+Coalesce(convert(nvarchar(1000),RoleID),Username) from dbo.PagePermission  where pageID=@PageID
GROUP BY RoleID,Username
SET @ROLEs= substring(@ROLEs,2,len(@ROLEs))
return @ROLEs
END





GO
