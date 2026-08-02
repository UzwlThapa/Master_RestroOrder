SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_ModuleMessageGet]
(
 @ModuleID INT,
 @Culture NVARCHAR(50)
)
AS
BEGIN
 SELECT 
  * 
 FROM 
  ModuleMessage 
 WHERE 
   ModuleID=@ModuleID 
  AND Culture=@Culture
END





GO
