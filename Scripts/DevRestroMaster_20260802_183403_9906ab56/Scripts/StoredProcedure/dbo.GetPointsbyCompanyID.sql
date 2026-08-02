SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetPointsbyCompanyID]
@CompanyID int
as begin 
select * from RO_PointScheme where CompanyID=@CompanyID
end



GO
