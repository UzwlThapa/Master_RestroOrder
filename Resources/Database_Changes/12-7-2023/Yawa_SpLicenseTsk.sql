SET QUOTED_IDENTIFIER ON;
SET ANSI_NULLS ON;
GO

/*
====================================
	Author: Yawahang
    Creadted Date: 12/7/2023
	Description: License Create for tenant
====================================

EXEC dbo.SpLicenseTsk 'RO-CHICKENSTATION','12/7/2023','12/7/2024'

*/
CREATE PROCEDURE dbo.SpLicenseTsk
    @CompanyCode VARCHAR (200) ,
    @ValidFrom SMALLDATETIME ,
    @ValidTo SMALLDATETIME
AS
    BEGIN;

        IF NOT EXISTS ( SELECT TOP ( 1 ) 1
                        FROM   dbo.Tenant AS t
                        WHERE  t.CompanyCode = @CompanyCode )
            BEGIN
                INSERT INTO dbo.Tenant ( CompanyCode ,
                                         ValidFrom ,
                                         ValidTo )
                            SELECT @CompanyCode ,
                                   @ValidFrom ,
                                   @ValidTo;
            END;
        ELSE
            BEGIN
                UPDATE t
                SET    t.ValidFrom = @ValidFrom ,
                       t.ValidTo = @ValidTo
                FROM   dbo.Tenant AS t
                WHERE  t.CompanyCode = @CompanyCode;

            END; 
    END;