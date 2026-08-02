SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--select * from dbo.tbl_CusOrder
CREATE PROCEDURE [dbo].[USP_INSERT_CUSORDER]
(
	@OrderID int,
    @Name nvarchar(256),
	@OrderDate nvarchar(256),
	@OrderTime nvarchar(256),
	@AppoinmentReceiveTime nvarchar(256)=null,
	@AppoinmentReceiveDate nvarchar(256)=null,
	@CellNo nvarchar(50)=null,
	@isTakeAwayhome bit=null,
	@FullAddress nvarchar(MAX)=null,
	@Message nvarchar(500)=null,
	@People int
)
AS

BEGIN
	if(@OrderID = 0) 
	Begin
		INSERT INTO dbo.tbl_CusOrder (
		Name, 
		OrderDate, 
		OrderTime, 
		AppoinmentReceiveTime, 
		AppoinmentReceiveDate,
		CellNo,
		isTakeAwayhome,
		FullAddress,
		[Message],
		[People]
		)  VALUES (@Name, @OrderDate, @OrderTime, @AppoinmentReceiveTime, @AppoinmentReceiveDate, @CellNo,@isTakeAwayhome,@FullAddress,@Message,@People)select @@IDENTITY
	end
else
	begin
	update  dbo.tbl_CusOrder set 
		Name = @Name,
		OrderDate = @OrderDate,
		OrderTime = @OrderTime,
		AppoinmentReceiveDate = @AppoinmentReceiveDate,
		AppoinmentReceiveTime = @AppoinmentReceiveTime,

		CellNo = @CellNo,
		isTakeAwayhome = @isTakeAwayhome,
		FullAddress = @FullAddress

	end
END






GO
