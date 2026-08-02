SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_ro_getProviderForCloseDay]
as
DECLARE @PreviousMaxPeriod DATE
			,@PreviousClosedTS DATETIME

	SELECT  @PreviousMaxPeriod=Max(Period),@PreviousClosedTS=max(ClosedTS)
	FROM DailyFinancialReport WHERE IsClosed=1  

	--select @PreviousMaxPeriod , @PreviousClosedTS

IF (OBJECT_ID('tempdb..#temp1') is not null)
	drop table #temp1
	IF (OBJECT_ID('tempdb..#temp2') is not null)
	drop table #temp2

		select PaymentMode,ProviderName,ProviderID,sum(PayAmount) as PayAmount into #temp1
		 from (
		    SELECT isnull(sum(mp.PayAmount),0)  as PayAmount, pm.PaymentMode, cd.ProviderName, pm.PaymentModeID, mpm.ProviderID
					FROM RO_MemberPay mp
					left join RO_MemberPaymentMode mpm on mpm.MemberPayId = mp.MemberPayID
					left join RO_PaymentModes pm on pm.PaymentModeID = mpm.PaymentModeID
					left join RO_CardProvider cd on cd.ProviderID = mpm.ProviderID
					WHERE (
							(mp.AddedOn BETWEEN @PreviousClosedTS AND getdate()) or @PreviousClosedTS is null)
							and mpm.PaymentModeID = 2
							group by pm.PaymentMode,  cd.ProviderName, pm.PaymentModeID, mpm.ProviderID 
			union all
				SELECT isnull(sum(apm.PayAmount), 0) as PayAmount, pm.PaymentMode, cd.ProviderName, pm.PaymentModeID, apm.ProviderID
				FROM Ro_RoomBookings rb
					INNER JOIN RO_OrderMasters om on rb.OrderMasterId=om.OrderMasterID
				left join RO_AdvancePaymentMode apm on apm.RoomBookDetailsId = rb.RoomBookDetailsId
				left join RO_PaymentModes pm on pm.PaymentModeID = apm.PaymentModeID
								left join RO_CardProvider cd on cd.ProviderID = apm.ProviderID
				WHERE (
						(om.Date BETWEEN @PreviousClosedTS
							AND getdate()) or @PreviousClosedTS is null
						)
						and apm.PaymentModeID = 2 and om.IsCancelled=0
						group by pm.PaymentMode, cd.ProviderName, pm.PaymentModeID, apm.ProviderID
			union all

	select isnull(sum(spm.PayAmount),0) as PayAmount, pm.PaymentMode, cd.ProviderName, pm.PaymentModeID, spm.ProviderID
        FROM ro_salesmaster sm
		inner join CBMS_BillPostLog cb on cb.SalesMasterId = sm.salesMasterId
		LEFT JOIN RO_SalesPaymentMode spm ON sm.salesMasterId = spm.salesMasterId
		left join RO_PaymentModes pm on pm.PaymentModeID = spm.PaymentModeID
		left join RO_CardProvider cd on cd.ProviderID = spm.ProviderID
			WHERE sm.IsArchived = 0
			AND sm.IsUpdated = 1
			AND (
				(sm.BillDate BETWEEN @PreviousClosedTS
					AND getdate()) or @PreviousClosedTS is null
				)
				and spm.PaymentModeID = 2 

				group by pm.PaymentMode, cd.ProviderName, pm.PaymentModeID, spm.ProviderID
		) x group by PaymentMode,ProviderName,ProviderID


		select PaymentMode,ProviderName,ProviderID,sum(PayAmount) as  Pay  into #temp2
		 from (
		    SELECT isnull(sum(mp.PayAmount),0) as PayAmount, pm.PaymentMode, cd.ProviderName, pm.PaymentModeID, mpm.ProviderID
					FROM RO_MemberPay mp
					left join RO_MemberPaymentMode mpm on mpm.MemberPayId = mp.MemberPayID
					left join RO_PaymentModes pm on pm.PaymentModeID = mpm.PaymentModeID
					left join RO_CardProvider cd on cd.ProviderID = mpm.ProviderID
					WHERE (
							(mp.AddedOn BETWEEN @PreviousClosedTS AND getdate()) or @PreviousClosedTS is null)
							and mpm.PaymentModeID = 3
					group by pm.PaymentMode,  cd.ProviderName, pm.PaymentModeID, mpm.ProviderID, mpm.ProviderID
		   union all
			SELECT isnull(sum(apm.PayAmount),0) as PayAmount, pm.PaymentMode, cd.ProviderName, pm.PaymentModeID, apm.ProviderID
						FROM Ro_RoomBookings rb
								INNER JOIN RO_OrderMasters om on rb.OrderMasterId=om.OrderMasterID
								left join RO_AdvancePaymentMode apm on apm.RoomBookDetailsId = rb.RoomBookDetailsId
								left join RO_PaymentModes pm on pm.PaymentModeID = apm.PaymentModeID
									left join RO_CardProvider cd on cd.ProviderID = apm.ProviderID
								WHERE (
										(om.Date BETWEEN @PreviousClosedTS
											AND getdate()) or @PreviousClosedTS is null
										)
										and apm.PaymentModeID = 3 and om.IsCancelled=0

								group by pm.PaymentMode, cd.ProviderName, pm.PaymentModeID, apm.ProviderID
			union all
		   	select isnull(sum(spm.PayAmount),0) as PayAmount, pm.PaymentMode, cd.ProviderName, pm.PaymentModeID, spm.ProviderID
        FROM ro_salesmaster sm
		inner join CBMS_BillPostLog cb on cb.SalesMasterId = sm.salesMasterId
		LEFT JOIN RO_SalesPaymentMode spm ON sm.salesMasterId = spm.salesMasterId
		left join RO_PaymentModes pm on pm.PaymentModeID = spm.PaymentModeID
		left join RO_CardProvider cd on cd.ProviderID = spm.ProviderID
			WHERE sm.IsArchived = 0
			AND sm.IsUpdated = 1
			AND (
				(sm.BillDate BETWEEN @PreviousClosedTS
					AND getdate()) or @PreviousClosedTS is null
				)
				and spm.PaymentModeID = 3

				group by pm.PaymentMode, cd.ProviderName, pm.PaymentModeID, spm.ProviderID
		) x group by PaymentMode,ProviderName,ProviderID

		Select ProviderName, ProviderID, sum(Cheque) as Cheque, sum(CARD) as Card from 
		(
		Select ProviderName, ProviderID, isnull(PayAmount,0) as Cheque, 0 as Card from #temp1 
		Union 
		Select ProviderName, ProviderID, 0 as Cheque, isnull(Pay,0) as Card from #temp2
		)x group by ProviderName, ProviderID

GO
