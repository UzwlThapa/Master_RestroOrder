SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================  
-- Author:  <Saroj Kumar Chaudhary>  
-- Create date: <10-Jan-2021>  
-- Description: <Get billing term>  
-- EXECUTE: [dbo].[USP_RO_GetBillInfo] 1,'' 
-- ============================================= 

CREATE PROCEDURE [dbo].[USP_RO_GetBillInfo] 
@salesMasterId int
,@SalesType varchar(30) = null
as
declare @code nvarchar(10)

select top (1) @code = Code from RO_CompanyInfo

if(isnull(@SalesType,'') = '')
begin
	select @code+fy.fyName+'-'+ cast((sm.InvoiceNo-fy.FirstSalesMasterID) as nvarchar) as InvoiceNo
,bp.invoice_date as InvoiceDate
,isnull(sm.IsArchived,0) as IsArchived
,ISNULL(sm.BillCancelled, 0) as IsCancelled
,brp.credit_note_number as CreditNoteNumber
,brp.credit_note_date as CreditNoteDate
,brp.reason_for_return as CreditNoteReason
,(sm.NetAmount - sm.AdvancePayment) as TotalAmount
,sm.CusID as CustomerID
,sm.CusName as CustomerName
 from RO_SalesMaster sm
 inner join RO_fiscalYear fy on sm.FiscalYearID = fy.fyId
left join CBMS_BillPostLog bp on bp.SalesMasterId = sm.salesMasterId and lower(isnull(bp.SalesType,'')) = ''
left join CBMS_BillReturnPostLog brp on brp.SalesMasterId = sm.salesMasterId and lower(isnull(brp.SalesType,'')) = ''
where sm.salesMasterId = @salesMasterId 
end
else
begin
	select @code+fy.fyName+'-'+ cast((sm.InvoiceNo-fy.FirstSalesMasterID) as nvarchar) as InvoiceNo
,bp.invoice_date as InvoiceDate
,isnull(sm.IsArchived,0) as IsArchived
,0
,brp.credit_note_number as CreditNoteNumber
,brp.credit_note_date as CreditNoteDate
,brp.reason_for_return as CreditNoteReason
,(sm.NetAmount - sm.AdvancePayment) as TotalAmount
,0 as CustomerID
,sm.CustomerName as CustomerName
 from RO_CakeSalesMaster sm
 inner join RO_fiscalYear fy on sm.FiscalYearID = fy.fyId
left join CBMS_BillPostLog bp on bp.SalesMasterId = sm.salesMasterId and lower(isnull(bp.SalesType,'')) = lower(isnull(sm.SalesType,'')) 
left join CBMS_BillReturnPostLog brp on brp.SalesMasterId = sm.salesMasterId and lower(isnull(brp.SalesType,'')) = lower(isnull(sm.SalesType,'')) 
where sm.SalesMasterId = @salesMasterId and lower(isnull(sm.SalesType,'')) = lower(@SalesType)
end


GO
