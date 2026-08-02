SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- DROP  PROCEDURE [dbo].[USP_ROI_GoodReceivedDetailsSave]
CREATE PROCEDURE [dbo].[USP_ROI_GoodReceivedDetailsSave]
@GMId int,
@PDId int,
@STId int,
@Qnty decimal(18,2),
@Rate decimal(18,2),
@Total decimal(18,2),
@Discount decimal(18,2),
@IsVat bit
as
begin
	INSERT INTO RO_GoodsReceivedDetls(GMId, PDId, Qnty, STId, Rate, Total, Discount, IsVat) 
	VALUES (@GMId, @PDId, @Qnty,@STId, @Rate, @Total, @Discount, @IsVat) 
END

GO
