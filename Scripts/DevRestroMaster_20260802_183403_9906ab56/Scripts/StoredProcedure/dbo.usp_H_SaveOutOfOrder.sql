SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--select * from RO_OutOfOrder
--[usp_H_SaveOutOfOrder] '16','1','5','No','Good washing','Superuser','Do'
CREATE PROCEDURE [dbo].[usp_H_SaveOutOfOrder]
-- Add the parameters for the stored procedure here

@OutOfOrderID	int,
@RoomID int,
@OO_Status	nvarchar(250),
@FromDate	nvarchar(250),
@ThroughDate varchar(128),
@ReturnAs varchar(128),
@Reason nvarchar(250),
@OO_Remarks nvarchar(50),
@IsOutOfOrder nvarchar(500),
@IsOutOfService nvarchar(500)

AS
BEGIN
IF	(@OutOfOrderID = 0)

INSERT INTO RO_OutOfOrder(
RoomID,
OO_Status,
FromDate,
ThroughDate,
ReturnAs,
Reason,
OO_Remarks,
IsOutOfOrder,
IsOutOfService
)
VALUES
(
@RoomID,
@OO_Status,
@FromDate,
@ThroughDate,
@ReturnAs,
@Reason,
@OO_Remarks,
@IsOutOfOrder,
@IsOutOfService
)
ELSE
UPDATE RO_OutOfOrder
	SET			
		RoomID = @RoomID,
		OO_Status = @OO_Status,
		FromDate = @FromDate,
		ThroughDate = @ThroughDate,
		ReturnAs = @ReturnAs,
		Reason = @Reason,
		OO_Remarks = @OO_Remarks,
		IsOutOfOrder = @IsOutOfOrder,
		IsOutOfService = @IsOutOfService

	WHERE OutOfOrderID= @OutOfOrderID
END



GO
