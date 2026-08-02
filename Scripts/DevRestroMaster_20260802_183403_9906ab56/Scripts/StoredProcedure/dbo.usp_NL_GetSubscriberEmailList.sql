SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:  <Author,,Name>
-- Create date: <Create Date,,>
-- Description: <Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[usp_NL_GetSubscriberEmailList] 
 @PortalID INT
AS
BEGIN
 SELECT *FROM DBO.NL_EmailSubscriber WHERE IsSubscribed=1 AND PortalID=@PortalID
END





GO
