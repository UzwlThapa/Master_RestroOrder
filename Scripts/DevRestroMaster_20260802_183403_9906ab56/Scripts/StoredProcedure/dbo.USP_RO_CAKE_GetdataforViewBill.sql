SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================  
-- Author:  <Saroj Kumar Chaudhary>  
-- Create date: <10-Jan-2021>  
-- Description: <Get Cake/Wholesales sales details>  
-- EXECUTE: USP_RO_CAKE_GetdataforViewBill 244,'wholesale' 
-- ============================================= 
CREATE PROCEDURE [dbo].[USP_RO_CAKE_GetdataforViewBill] @SalesMasterId INT
,@SalesType varchar(30)
AS
BEGIN

	DECLARE @code VARCHAR(10)

	SET @code = (
			SELECT TOP (1) Code
			FROM RO_CompanyInfo
			)

	SELECT * FROM 
	(
		SELECT SD.ItemId
			,ISNULL(SD.Quantity, 0) Quantity
			,ISNULL(SD.Rate, 0) Rate
			
			,SM.OrderMasterId OrderMasterId
			,'' Note
			,0 ExtraCharge
			,it.ITName
			,SM.BillDate DATE
			,SM.NepaliInvoiceDate
			,SM.BasicAmount			
			--,sm.totaldiscount
			--,ISNULL(SM.IsFlatDis, 0) isflatdis
			--,ISNULL(SM.DiscountValue, 0) DiscountValue
			,SM.NetAmount
			,SM.TenderAmount
			,SM.ReturnAmount
			--(select max(PrintedNumber) from PrintDetail where PrintBillNo=sm.salesMasterId) as PrintCount,  
			,isnull(sm.PrintCount, 0) AS PrintCount
			,@code + fy.fyName + '-' + cast((sm.InvoiceNo - fy.FirstSalesMasterID) AS VARCHAR) AS BillNo
			,(fy.fyName) AS fiscalYear
			,SM.CustomerId CusID
			,case when sp.Customer = '' then SM.CustomerName else  isnull(sp.Customer, SM.CustomerName) END CusName 
			,SM.ContactNo
			,SM.PAN
			,SM.Address
			,SM.salesMasterId
			,SM.AddedBy AS Cashier			
			,isnull(SM.AdvancePayment, 0) AS AdvancePayment
			,ISNULL(OM.DeliveryService,'') DeliveryService
			,ISNULL(OM.DeliveryTime,'') DeliveryTime
		
		FROM RO_CakeSalesMaster SM
		LEFT JOIN RO_CakeSalesDetail SD ON SM.salesMasterId = SD.salesMasterId and lower(SM.SalesType) = lower(SD.SalesType)
		LEFT JOIN RO_fiscalYear fy ON fy.fyId = sm.FiscalYearID
		--LEFT JOIN RO_restroTable rt ON rt.restrotableId = sm.TableId		
		LEFT JOIN ROI_ITEMMain it ON it.ITId = sd.ItemId
		left join RO_Cake_SalesPaymentMode sp on sp.salesMasterId = SM.salesMasterId and lower(sp.SalesType) = lower(SM.SalesType)		
		left join RO_CakeOrderMaster OM ON OM.OrderMasterId = SM.OrderMasterId
		WHERE SM.salesMasterId = @SalesMasterId and lower(isnull(SM.SalesType,'')) = lower(Isnull(@SalesType,''))
			
	)  AS x
	ORDER BY  ITName



 update RO_CakeOrderMaster set StatusId = (select Id from RO_StatusMaster where LookUpName='paid' and lower(UseFor) = lower(@SalesMasterId)) 
	where  OrderMasterID = (select OrderMasterID from RO_CakeSalesMaster 
	where SalesMasterId = @SalesMasterId and lower(isnull(SalesType,'')) = lower(Isnull(@SalesType,'')))

END

GO
