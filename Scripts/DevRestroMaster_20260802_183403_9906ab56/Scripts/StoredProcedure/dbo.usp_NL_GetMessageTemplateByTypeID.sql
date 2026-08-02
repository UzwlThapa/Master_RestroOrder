SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:  <Author,,Name>
-- Create date: <Create Date,,>
-- Description: <Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[usp_NL_GetMessageTemplateByTypeID]--1,'EN-US',1
@MessageTemplateTypeID INT,
@Culture NVARCHAR(50),
@PortalID INT
AS
BEGIN
SELECT MessageTemplateID,[Subject],Body FROM DBO.MessageTemplate
WHERE MessageTemplateTypeID=@MessageTemplateTypeID AND Culture=@Culture and PortalID=@PortalID 
END





GO
