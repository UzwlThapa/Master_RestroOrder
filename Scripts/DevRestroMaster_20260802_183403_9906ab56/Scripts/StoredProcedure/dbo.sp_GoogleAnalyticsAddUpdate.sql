SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_GoogleAnalyticsAddUpdate]
 @GoogleJSCode NVARCHAR(1500),
 @IsActive BIT, 
 @PortalID INT,
 @AddedBy NVARCHAR(256)
AS
IF NOT EXISTS
(
 SELECT * FROM [dbo].[GoogleAnalytics] WHERE
 PortalID = @PortalID
)
 BEGIN
  INSERT INTO [dbo].[GoogleAnalytics] (
   [GoogleJSCode],
   [IsActive],
   [IsModified],
   [AddedOn],
   [UpdatedOn],
   [PortalID],
   [AddedBy]
  ) VALUES (
   @GoogleJSCode,
   @IsActive,
   0,
   GETDATE(),
   GETDATE(),
   @PortalID,
   @AddedBy
  )
 END
ELSE
 BEGIN
  UPDATE [dbo].[GoogleAnalytics] SET
   [GoogleJSCode] = @GoogleJSCode,
   [IsActive] = @IsActive,
   [IsModified] = 1,   
   [UpdatedOn] = GETDATE(),  
   [UpdatedBy] = @AddedBy
  WHERE
   @PortalID = @PortalID
 END





GO
