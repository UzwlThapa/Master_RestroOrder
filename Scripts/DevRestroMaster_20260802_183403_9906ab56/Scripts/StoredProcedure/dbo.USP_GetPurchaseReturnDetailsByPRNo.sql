SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--DROP PROCEDURE [dbo].[USP_GetPurchaseReturnDetailsByPRNo]
CREATE PROCEDURE [dbo].[USP_GetPurchaseReturnDetailsByPRNo]
@PRNo varchar(20)
as
BEGIN
select   pm.PostedOn,
Im.ITName as ItemName, pd.Qnty,Gd.Rate, u1.Symbol
 ,convert(numeric(10,2), ISNULL((pd.Qnty * gd.Rate),0)) as Total
   ,rl.Fname
  ,rl.Address+ ', ' + rl.City + ', ' + rl.Country as Address
   ,rl.TelWork
      	,(
			SELECT isnull(stuff((
							SELECT ' & ' + pms.PaymentMode
							FROM RO_PurchaseReturnPaymentMode spm
							INNER JOIN RO_PaymentModes pms ON spm.paymentModeID = pms.PaymentModeID
							WHERE spm.PurchaseReturnId = pm.PurchaseReturnId --and spm.PaymentModeID = 4
							FOR XML PATH('')
								,TYPE
							).value('.', 'NVARCHAR(MAX)'), 1, 3, ''), '')
			) AS PayMode
			,gm.InvoiceNo
			,pm.NepaliInvoiceDate
			,pm.PRNote
			,fy.fyName
 from RO_PurchaseReturnDetails pd 
inner join RO_PurchaseReturnMain pm  on pm.PurchaseReturnId=pd.PurchaseReturnId
inner join ROI_ITEMMain IM ON IM.ITId = PD.ItemID
LEFT JOIN ROI_Unit1 u1 ON u1.Unit1Id = pd.UsedUnitID
left join RO_GoodsReceivedDetls GD on GD.GDId=pd.GDId
left  join RO_GoodsReceivedMain GM ON GM.GMId = GD.GMId
left join RO_LoyaltyMembership rl on rl.MembershipID = GM.vendorId
left join RO_PurchaseReturnPaymentMode ppm on ppm.PurchaseReturnId = pm.PurchaseReturnId
left join RO_fiscalYear fy on fy.fyId = pm.FyId
where pm.PRNo = @PRNo
 GROUP BY  pm.PostedOn,Im.ITName, pd.Qnty,Gd.Rate, u1.Symbol,rl.Fname
  ,rl.Address,rl.City,rl.Country,rl.TelWork, pm.PurchaseReturnId,gm.InvoiceNo ,pm.NepaliInvoiceDate
			,pm.PRNote
			,fy.fyName
END

GO
