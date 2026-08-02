SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--DROP PROCEDURE [usp_saveCanceledOrderDetailItem]

CREATE PROCEDURE [dbo].[usp_saveCanceledOrderDetailItem] @CanceledBy NVARCHAR(max)
	,@OrderBy NVARCHAR(max)
	,@Item NVARCHAR(max)
	,@Quantity FLOAT
	,@Reason NVARCHAR(max)
	,@Date NVARCHAR(max)
	,@Responsible NVARCHAR(max)
	,@tableid INT
	,@orderMasterID INT
AS

INSERT INTO Order_Detail_Cancel (
	CanceledBy
	,OrderBy
	,Item
	,Quantity
	,Reason
	,DATE
	,Responsible
	,tableid
	,orderMasterID
	)
VALUES (
	@CanceledBy
	,@OrderBy
	,@Item
	,@Quantity
	,@Reason
	,@Date
	,@Responsible
	,@tableid
	,@orderMasterID
	)

GO
