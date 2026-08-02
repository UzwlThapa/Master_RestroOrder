SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_roi_goodsreceiveDelete]
@GMId INT
as
begin
DELETE FROM DBO.RO_GoodsReceivedMain  WHERE GMId = @GMId
end











GO
