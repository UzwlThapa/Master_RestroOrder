SET QUOTED_IDENTIFIER ON;
SET ANSI_NULLS ON;
GO

/*
====================================
	Author: Yawahang
    Creadted Date: 12/7/2023
	Description: License select for tenant
====================================

EXEC dbo.SpLicenseSel 'RO-CHICKENSTATION'

*/
CREATE PROCEDURE dbo.SpLicenseSel
    @CompanyCode VARCHAR (200)
AS
    BEGIN;
        IF NOT EXISTS ( SELECT TOP ( 1 ) 1
                        FROM   dbo.Tenant AS t
                        WHERE  t.CompanyCode = @CompanyCode )
            BEGIN
                SELECT @CompanyCode AS CompanyCode ,
                       0 AS ValidDays
                FROM   dbo.Tenant AS t;
            END;
        ELSE
            BEGIN
                SELECT t.CompanyCode ,
                       DATEDIFF (DAY, GETDATE (), t.ValidTo) AS ValidDays
                FROM   dbo.Tenant AS t
                WHERE  t.CompanyCode = @CompanyCode;

            END;

    END;