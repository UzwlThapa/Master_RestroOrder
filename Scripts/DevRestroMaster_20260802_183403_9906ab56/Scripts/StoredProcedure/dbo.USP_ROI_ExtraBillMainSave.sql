SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_ROI_ExtraBillMainSave]
@CustomerName nvarchar(256),
@IssueDate nvarchar(256),
@Pan nvarchar(256),
@NetTotal nvarchar(256),
@Discount nvarchar(256),
@Vat nvarchar(256),
@GrandTotal nvarchar(256)

as
begin
	INSERT INTO tbl_ExtraBillingMaster (
	CustomerName,
	IssueDate,
	Pan,
	NetTotal,
	Discount,
	Vat,
	GrandTotal
	) 
	VALUES (
	
	@CustomerName,
	@IssueDate,
	@Pan,
	@NetTotal,
	@Discount,
	@Vat,
	@GrandTotal
	)
	SELECT @@IDENTITY
END




GO
