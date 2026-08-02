SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_GetCancelledOrderBY]
as BEGIN
select distinct OrderBy from Order_Detail_Cancel
where OrderBy is not null and OrderBy != '';
END

GO
