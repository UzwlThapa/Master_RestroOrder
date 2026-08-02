SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Usp_getGoodsReceiveMain]
as
select distinct gm.GMId, gm.GMNo from RO_GoodsReceivedMain gm 
Left join RO_GoodsReceivedDetls gd on gm.GMId = gd.GMId
WHERE gd.Qnty > (
		SELECT isnull(sum(pd.Qnty), 0)
		FROM RO_PurchaseReturnDetails pd
		WHERE pd.GDId = gd.GDId
		) 
		--and cast(gm.InvoiceDate as date) >= cast(dateadd(mm, -1, getdate()) as  date)
		order  by gm.GMId DESC



GO
