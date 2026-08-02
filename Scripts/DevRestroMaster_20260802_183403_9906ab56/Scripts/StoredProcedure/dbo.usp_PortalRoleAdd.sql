SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_PortalRoleAdd] 
 @PortalID INT,
 @RoleID  UNIQUEIDENTIFIER,
 @IsActive BIT,
 @AddedOn DATETIME,
 @AddedBy NVARCHAR(256)
AS
INSERT INTO [dbo].PortalRole (
 [PortalID],
 [RoleID],
 [IsActive],
 [AddedOn],
 [AddedBy]
)
VALUES( 
 @PortalID,
 @RoleId,
 @IsActive,
 @AddedOn,
 @AddedBy
)





GO
