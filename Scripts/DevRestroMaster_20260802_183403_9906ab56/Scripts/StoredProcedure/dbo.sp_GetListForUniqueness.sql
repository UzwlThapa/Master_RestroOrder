SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:  <Author,,Name>
-- Create date: <Create Date,,>
-- Description: <Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetListForUniqueness] 
 -- Add the parameters for the stored procedure here
 @ListName Nvarchar(500),
 @Culture NVARCHAR(256),
 @ParentId int
AS
BEGIN
SELECT * FROM dbo.Lists WHERE ListName=@ListName AND Culture=@Culture AND ParentID = @ParentId
END





GO
