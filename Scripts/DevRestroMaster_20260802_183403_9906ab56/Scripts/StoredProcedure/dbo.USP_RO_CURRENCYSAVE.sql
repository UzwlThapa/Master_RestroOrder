SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[USP_RO_CURRENCYSAVE]
(
@CurrencyID int,
@CurrencyName nvarchar(150),
@SubCurrencyName nvarchar(150),
@CurrencyIcon nvarchar(10)

)
AS

if(@CurrencyID = 0)
BEGIN
INSERT INTO RO_Currency(CurrencyName, SubCurrencyName, CurrencyIcon) values(@CurrencyName, @SubCurrencyName, @CurrencyIcon)
END
else
begin
Update dbo.RO_Currency Set

CurrencyName = @CurrencyName,
SubCurrencyName= @SubCurrencyName,
CurrencyIcon = @CurrencyIcon
WHERE CurrencyID=@CurrencyID

 end









GO
