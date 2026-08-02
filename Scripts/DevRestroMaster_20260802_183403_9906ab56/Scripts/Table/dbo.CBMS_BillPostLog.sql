SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CBMS_BillPostLog](
	[LogID] [int] IDENTITY(1,1) NOT NULL,
	[seller_pan] [nvarchar](256) NULL,
	[buyer_pan] [nvarchar](256) NULL,
	[fiscal_year] [nvarchar](256) NULL,
	[buyer_name] [nvarchar](256) NULL,
	[invoice_number] [nvarchar](256) NULL,
	[invoice_date] [nvarchar](256) NULL,
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
	[BillPostDateTime] [datetime] NULL,
	[StatusCode] [nvarchar](256) NULL,
	[StatusDetails] [nvarchar](256) NULL,
	[SalesMasterId] [int] NULL,
	[EnglishInvDate] [nvarchar](max) NULL,
	[SalesType] [nvarchar](30) NULL,
PRIMARY KEY CLUSTERED 
(
	[LogID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
CREATE NONCLUSTERED INDEX [IX_CBMS_BillPostLog_SalesMasterId] ON [dbo].[CBMS_BillPostLog]
(
	[SalesMasterId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE TRIGGER [dbo].[CBMS_BillPostLog_Delete] ON [dbo].[CBMS_BillPostLog] 
FOR DELETE
AS
ROLLBACK TRANSACTION
	RAISERROR ('Update and Deletions not allowed from this table', 16, 1)

GO
ALTER TABLE [dbo].[CBMS_BillPostLog] ENABLE TRIGGER [CBMS_BillPostLog_Delete]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE TRIGGER [dbo].[CBMS_BillPostLog_UPDATE] ON [dbo].[CBMS_BillPostLog]
FOR UPDATE
AS

--IF EXISTS(SELECT * FROM DELETED d WHERE LTRIM(RTRIM(d.StatusCode))='200')
--BEGIN
--ROLLBACK TRANSACTION
--RAISERROR ('Update and Deletions not allowed from this table' , 16, 1)
--END

IF (
SELECT  count(1) FROM INSERTED i INNER JOIN DELETED d ON  i.LogID=d.LogID AND  i.seller_pan=d.seller_pan AND  i.buyer_pan=d.buyer_pan AND  i.fiscal_year=d.fiscal_year AND  i.buyer_name=d.buyer_name 
AND  i.invoice_number=d.invoice_number --AND  i.invoice_date=d.invoice_date 
AND  i.total_sales=d.total_sales AND  i.taxable_sales_vat=d.taxable_sales_vat 
AND  i.vat=d.vat AND  i.excisable_amount=d.excisable_amount AND  i.excise=d.excise AND  i.taxable_sales_hst =d.taxable_sales_hst AND  i.hst=d.hst 
AND  i.amount_for_esf=d.amount_for_esf AND  i.esf=d.esf AND  i.export_sales=d.export_sales AND  i.tax_exempted_sales=d.tax_exempted_sales 
AND   i.datetimeClient=d.datetimeClient AND  i.SalesMasterId=d.SalesMasterId and i.EnglishInvDate=d.EnglishInvDate
  ) = 0
BEGIN
ROLLBACK TRANSACTION
	RAISERROR ('Update and Deletions not allowed from this table' , 16, 1)
END

GO
ALTER TABLE [dbo].[CBMS_BillPostLog] ENABLE TRIGGER [CBMS_BillPostLog_UPDATE]
GO
