SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_GetOrderCancelledBY]
as BEGIN
select distinct CanceledBy from Order_Detail_Cancel
where CanceledBy is not null and CanceledBy != '';

END

GO
