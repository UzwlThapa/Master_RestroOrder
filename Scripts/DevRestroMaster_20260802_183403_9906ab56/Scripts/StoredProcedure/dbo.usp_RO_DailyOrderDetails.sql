SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[usp_RO_DailyOrderDetails] 
	-- Add the parameters for the stored procedure here
	AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT [OrderMasterID],[restroRoom]as RoomName,[restrotableTitle] as TableName,[BillNo],[BasicAmount]  FROM 
RO_OrderMasters om join RO_restroTable rt 
on om.TableId = rt.restrotableId
Join RO_RestroRoom rr on om.RoomId = rr.restroRoomId
WHERE CAST(om.Date as date) = CAST(GETDATE() as date)

--where CAST(om.Date as date) = '2016-12-16' 
END




GO
