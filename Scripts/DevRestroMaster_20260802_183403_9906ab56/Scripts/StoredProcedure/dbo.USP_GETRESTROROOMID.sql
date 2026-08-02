SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_GETRESTROROOMID]
 @restroRoomId INT
AS
BEGIN
	 Select * from RO_restroTable where restroRoomId = @restroRoomId
END

GO
