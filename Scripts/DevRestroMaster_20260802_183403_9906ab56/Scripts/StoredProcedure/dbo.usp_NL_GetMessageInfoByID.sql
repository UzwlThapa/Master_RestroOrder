SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:  <Author,,Name>
-- Create date: <Create Date,,>
-- Description: <Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[usp_NL_GetMessageInfoByID]
@messageTemplateID INT
AS
BEGIN
 SELECT * FROM DBO.MessageTemplate WHERE MessageTemplateID=@messageTemplateID
END





GO
