
-- tenant table with license
CREATE TABLE dbo.Tenant
(   TenantId [UNIQUEIDENTIFIER] NOT NULL  DEFAULT (NEWID()),
CompanyCode VARCHAR(200) NOT NULL,
    ValidFrom [SMALLDATETIME] NOT NULL ,
    ValidTo [SMALLDATETIME] NOT NULL ,
    CreatedDate [SMALLDATETIME] NOT NULL
        DEFAULT ( GETDATE ()) ,
    [ModifiedDate] [SMALLDATETIME] NOT NULL
        DEFAULT ( GETDATE ()));

