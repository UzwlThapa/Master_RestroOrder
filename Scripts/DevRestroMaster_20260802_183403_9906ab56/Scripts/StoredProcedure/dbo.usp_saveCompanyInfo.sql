SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_saveCompanyInfo] @companyId INT
	,@Name VARCHAR(128)
	,@RegistrationNo VARCHAR(128)
	,@Address VARCHAR(128)
	,@Country VARCHAR(128)
	,@Logo VARCHAR(128)
	,@PhoneNo VARCHAR(128)
	,@PAN VARCHAR(128)
	,@CurrencyID INT
	,@IsPan BIT
	,@CBMSUserName NVARCHAR(128)
	,@CBMSPassword NVARCHAR(128)
	,@Code VARCHAR(10)
	,@IsAbbreviated BIT
AS
BEGIN
	DECLARE @val INT

	SET @val = (
			SELECT count(*)
			FROM RO_CompanyInfo ci
			)

	IF (@val = 0)
	BEGIN
		INSERT INTO dbo.RO_CompanyInfo (
			NAME
			,RegistrationNo
			,Address
			,Country
			,Logo
			,PhoneNo
			,PAN
			,CurrencyID
			,IsPan
			,CBMSUserName
			,CBMSPassword
			,Code
			,IsAbbreviated
			)
		VALUES (
			@Name
			,@RegistrationNo
			,@Address
			,@Country
			,@Logo
			,@PhoneNo
			,@PAN
			,@CurrencyID
			,@IsPan
			,@CBMSUserName
			,@CBMSPassword
			,@Code
			,@IsAbbreviated
			)
	END
	ELSE
	BEGIN
		UPDATE dbo.RO_CompanyInfo
		SET NAME = @Name
			,RegistrationNo = @RegistrationNo
			,ADDRESS = @Address
			,Country = @Country
			,Logo = @Logo
			,PhoneNo = @PhoneNo
			,PAN = @PAN
			,CurrencyID = @CurrencyID
			,IsPan = @IsPan
			,CBMSUserName = @CBMSUserName
			,CBMSPassword = @CBMSPassword
			,IsAbbreviated = @IsAbbreviated
			,Code = CASE 
				WHEN (
						SELECT count(*)
						FROM RO_SalesMaster
						) > 0
					THEN Code
				ELSE @Code
				END
		WHERE ID = @companyId
	END
END


GO
