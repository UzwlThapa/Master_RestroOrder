SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_cbms_updatePostedBillLog] @logId INT
	,@statusCode NVARCHAR(256)
	,@status NVARCHAR(256)
	,@postedDate DATETIME
	,@salesMasterID INT
	,@isRealTime bit
AS
BEGIN
	UPDATE CBMS_BillPostLog
	SET StatusCode = @statusCode
		,StatusDetails = @status
		,BillPostDateTime = @postedDate
		,isrealtime = @isRealTime
	WHERE LogID = @logId
		AND SalesMasterId = @salesMasterID
END


GO
