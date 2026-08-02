SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[fn_getMaxMasterIdByRoom]
(
	
	@roomId varchar(128)
)
RETURNS int
AS
BEGIN
Declare @val varchar(128)
	select @val=max(m.OrderMasterID) from RO_OrderMasters m
	where m.RoomId=@roomId
	return @val
	
END





GO
