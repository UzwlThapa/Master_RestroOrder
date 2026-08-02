SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:  <Author,,Name>
-- Create date: <Create Date,,>
-- Description: <Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[usp_DeleteSystemEventStartUp]
@PortalStartUpID int,
@UserName nvarchar(256)
AS
BEGIN
 SET NOCOUNT ON;
   UPDATE dbo.PortalStartUp SET
     IsDeleted=1,
     DeletedOn=GETDATE(),
     DeletedBy=@UserName
    WHERE PortalStartUpID=@PortalStartUpID
END





GO
