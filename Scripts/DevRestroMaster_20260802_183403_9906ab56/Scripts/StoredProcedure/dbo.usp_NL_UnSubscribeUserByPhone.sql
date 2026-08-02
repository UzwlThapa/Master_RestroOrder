SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:  <Author,,Name>
-- Create date: <Create Date,,>
-- Description: <Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[usp_NL_UnSubscribeUserByPhone]
@Phone bigint
AS
BEGIN
 UPDATE DBO.NL_MobileSubsciber 
 SET IsSubscribed=0 WHERE MobileNumber=@Phone
END





GO
