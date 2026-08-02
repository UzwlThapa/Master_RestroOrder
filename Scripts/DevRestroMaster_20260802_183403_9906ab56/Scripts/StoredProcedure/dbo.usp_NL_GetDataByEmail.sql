SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:  <Author,,Name>
-- Create date: <Create Date,,>
-- Description: <Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[usp_NL_GetDataByEmail]
@Email NVARCHAR(128)
AS
BEGIN
 SELECT * FROM dbo.NL_EmailSubscriber WHERE SubscriberEmail=@Email AND IsSubscribed=1
END





GO
