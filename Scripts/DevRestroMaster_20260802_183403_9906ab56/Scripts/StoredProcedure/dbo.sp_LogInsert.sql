SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_LogInsert]
 @LogID INT = NULL OUTPUT,
 @LogTypeID INT,
 @Severity INT,
 @Message NVARCHAR(1000),
 @Exception NVARCHAR(4000),
 @ClientIPAddress NVARCHAR(100),
 @PageURL NVARCHAR(100),
 @IsActive BIT,
 @PortalID INT,
 @AddedBy NVARCHAR(256)
AS
BEGIN
 INSERT
 INTO [dbo].[Log]
 (
  LogTypeID,
  Severity,
  [Message],
  Exception,
  ClientIPAddress,
  PageURL,
  [IsActive],
  [AddedOn],
  [PortalID],
  [AddedBy]
 )
 VALUES
 (
  @LogTypeID,
  @Severity,
  @Message,
  @Exception,
  @ClientIPAddress,
  @PageURL,
  @IsActive,
  GETDATE(),
  @PortalID,
  @AddedBy
 )

 SET @LogID=@@IDENTITY
END





GO
