SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_RO_DELETECOMBO]
@ComboID INT,
@UserName nvarchar(200)
AS
BEGIN
update DBO.RO_Combo set IsDeleted = 1,
DeletedBy = @UserName,
DeletedOn=getdate() WHERE ComboID = @ComboID
END



GO
