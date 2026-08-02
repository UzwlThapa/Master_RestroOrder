SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- USP_ChangeBillInfo 1,0,'Shree Khanal','123456789','Testing'
CREATE PROCEDURE [dbo].[USP_ChangeBillInfo]
    @salesMasterId INT,
	@CusId INT,
	@CustomerName VARCHAR(50),
	@PAN VARCHAR(50),
	@Remarks VARCHAR(50)


AS
BEGIN

	BEGIN

	ALTER TABLE RO_SalesMaster DISABLE TRIGGER [RO_SalesMaster_UPDATE]
	UPDATE RO_SalesMaster SET CusName=@CustomerName, CusID=@CusId, PAN=@PAN, Reasons=@Remarks Where salesMasterId=@salesMasterId
	ALTER TABLE RO_SalesMaster ENABLE TRIGGER [RO_SalesMaster_UPDATE]


	ALTER TABLE RO_SalesPaymentMode DISABLE TRIGGER [RO_SalesPaymentMode_Delete]
	UPDATE RO_SalesPaymentMode SET Customer=@CustomerName, CusID=@CusId Where salesMasterId=@salesMasterId
	ALTER TABLE RO_SalesPaymentMode ENABLE TRIGGER [RO_SalesPaymentMode_Delete]
	END

END;

GO
