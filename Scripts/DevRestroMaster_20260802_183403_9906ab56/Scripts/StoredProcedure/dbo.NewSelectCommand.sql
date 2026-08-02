SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[NewSelectCommand]
AS
	SET NOCOUNT ON;
SELECT        tblPurchaseOrder.ItemName, tblPurchaseOrder.Quantity, tblPurchaseOrder.OrderId, RO_CompanyInfo.Name, RO_CompanyInfo.RegistrationNo, RO_CompanyInfo.Address, RO_CompanyInfo.Country, 
                         RO_CompanyInfo.PhoneNo, RO_CompanyInfo.Logo, RO_CompanyInfo.PAN, RO_CompanyInfo.CurrencyID
FROM            tblPurchaseOrder CROSS JOIN
                         RO_CompanyInfo

GO
