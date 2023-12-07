
-- create license
EXEC dbo.SpLicenseTsk @CompanyCode = 'RO-CHICKENSTATION' , -- varchar(200)
                      @ValidFrom = '2023-12-07 05:46:43' , -- smalldatetime
                      @ValidTo = '2024-12-07 05:46:43';    -- smalldatetime

EXEC dbo.SpLicenseSel @CompanyCode = 'RO-CHICKENSTATION'; -- varchar(200)
