SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_ROI_ExtraBillingDetailsSave]
@BillingID int,
@Item nvarchar(256),
@Rate nvarchar(256),
@Quantity nvarchar(256),
@Total nvarchar(256)
as
begin
	

	INSERT INTO tbl_ExtraBillingDetails(
	BillingID,
	Item,
	Rate,
	Quantity,
	Total
	
	) 
	VALUES (
	@BillingID,
	@Item,
	@Rate,
	@Quantity,
	@Total
	
	)
	--SELECT @@IDENTITY
END

select * from tbl_ExtraBillingDetails



GO
