SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ROI_SAVEPURCHASELOT]
@PurchaseDetailsID int,
@LotNo nvarchar(200)=null,
@BatchNo nvarchar(200)=null,
@ExpDate nvarchar(200)=null

as
begin
insert into ROI_PurchaseLotNo (PurchaseDetailsID,LotNo,BatchNo,ExpDate) 
values (@PurchaseDetailsID,@LotNo,@BatchNo,@ExpDate)
end

select * from ROI_PurchaseLotNo
select * from ROI_PurchaseMain
select * from ROI_PurchaseDetails




GO
