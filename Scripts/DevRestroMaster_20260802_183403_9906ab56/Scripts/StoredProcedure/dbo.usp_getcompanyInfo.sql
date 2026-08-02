SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_getcompanyInfo]
AS
BEGIN
 DECLARE @VatRate DECIMAL(14, 4) = 0;

    SELECT @VatRate = Rate
    FROM dbo.RO_BillTerm
    WHERE BilingID = 54; -- vat
	SELECT ci.ID AS companyId
		,ci.NAME
		,ci.RegistrationNo
		,ci.Address
		,ci.Country
		,ci.Logo
		,ci.PhoneNo
		,ci.PAN
		,ci.CurrencyID
		,ci.IsPan
		,ci.CBMSUserName
		,ci.CBMSPassword
		,ci.Code
		,ci.AbbreviatedValue
		,ci.IsAbbreviated
		,@VatRate AS VatRate
	FROM dbo.RO_CompanyInfo ci
END

GO
