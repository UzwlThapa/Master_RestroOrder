SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CBMS_BillReturnPostLog](
	[ReturnLogID] [int] IDENTITY(1,1) NOT NULL,
	[seller_pan] [nvarchar](256) NULL,
	[buyer_pan] [nvarchar](256) NULL,
	[fiscal_year] [nvarchar](256) NULL,
	[buyer_name] [nvarchar](256) NULL,
	[ref_invoice_number] [nvarchar](256) NULL,
	[credit_note_number] [nvarchar](256) NULL,
	[credit_note_date] [nvarchar](256) NULL,
	[reason_for_return] [nvarchar](256) NULL,
	[total_sales] [decimal](18, 2) NULL,
	[taxable_sales_vat] [decimal](18, 2) NULL,
	[vat] [decimal](18, 2) NULL,
	[excisable_amount] [decimal](18, 2) NULL,
	[excise] [decimal](18, 2) NULL,
	[taxable_sales_hst] [decimal](18, 2) NULL,
	[hst] [decimal](18, 2) NULL,
	[amount_for_esf] [decimal](18, 2) NULL,
	[esf] [decimal](18, 2) NULL,
	[export_sales] [decimal](18, 2) NULL,
	[tax_exempted_sales] [decimal](18, 2) NULL,
	[isrealtime] [bit] NULL,
	[datetimeClient] [datetime] NULL,
	[BillReturnDateTime] [datetime] NULL,
	[StatusCode] [nvarchar](256) NULL,
	[StatusDetails] [nvarchar](256) NULL,
	[SalesMasterId] [int] NULL,
	[SalesType] [nvarchar](30) NULL,
PRIMARY KEY CLUSTERED 
(
	[ReturnLogID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE TRIGGER [dbo].[CBMS_BillReturnPostLog_Delete] ON [dbo].[CBMS_BillReturnPostLog] 
FOR DELETE
AS
ROLLBACK TRANSACTION
	RAISERROR ('Update and Deletions not allowed from this table', 16, 1)

GO
ALTER TABLE [dbo].[CBMS_BillReturnPostLog] ENABLE TRIGGER [CBMS_BillReturnPostLog_Delete]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE TRIGGER [dbo].[CBMS_BillReturnPostLog_UPDATE] ON [dbo].[CBMS_BillReturnPostLog]
FOR UPDATE
AS

--IF EXISTS(SELECT * FROM DELETED d WHERE LTRIM(RTRIM(d.StatusCode))='200')
--BEGIN
--ROLLBACK TRANSACTION
--	RAISERROR ('Update not allowed from this table' , 16, 1)
--END

IF (
SELECT      count(1)   
FROM    INSERTED i INNER JOIN DELETED d ON  
i.ReturnLogID=d.ReturnLogID AND i.seller_pan=d.seller_pan AND i.buyer_pan=d.buyer_pan AND i.fiscal_year=d.fiscal_year AND i.buyer_name=d.buyer_name AND 
i.ref_invoice_number=d.ref_invoice_number AND i.credit_note_number=d.credit_note_number AND i.credit_note_date=d.credit_note_date AND
i.reason_for_return=d.reason_for_return AND i.total_sales=d.total_sales AND i.taxable_sales_vat=d.taxable_sales_vat AND i.vat=d.vat AND i.excisable_amount=d.excisable_amount AND
i.excise=d.excise AND i.taxable_sales_hst=d.taxable_sales_hst AND i.hst=d.hst AND i.amount_for_esf=d.amount_for_esf AND i.esf=d.esf AND i.export_sales=d.export_sales AND
i.tax_exempted_sales=d.tax_exempted_sales AND i.datetimeClient=d.datetimeClient  AND i.SalesMasterId=d.SalesMasterId
--AND d.StatusCode='200'
 ) = 0
BEGIN
ROLLBACK TRANSACTION
	RAISERROR ('Update not allowed from this table' , 16, 1)
END


GO
ALTER TABLE [dbo].[CBMS_BillReturnPostLog] ENABLE TRIGGER [CBMS_BillReturnPostLog_UPDATE]
GO
