SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_AvailableModulesUpdate]
 @FileName NVARCHAR(256)
AS
BEGIN

 SET NOCOUNT ON;
UPDATE [dbo].[AvailableModules]
SET [IsDeleted]=1 ,[DeletedOn]=GETDATE()
WHERE FolderName=@FileName

END





GO
