SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[USP_cbms_updateReturnedBill] @returnLogId INT
	,@statusCode NVARCHAR(256)
	,@status NVARCHAR(256)
	,@postedDate DATETIME
	,@salesMasterID INT
	,@isRealTime BIT
AS
BEGIN
	UPDATE CBMS_BillReturnPostLog
	SET StatusCode = @statusCode
		,StatusDetails = @status
		,BillReturnDateTime = @postedDate
		,isrealtime = @isRealTime
	WHERE ReturnLogID = @returnLogId
		AND SalesMasterId = @salesMasterID
END


GO
