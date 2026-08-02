SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_GetPointScheme]
as begin 
--SELECT   distinct rp.IsPercentage,  rp.CompanyID, rc.Name as CompanyName
--FROM            RO_PointScheme rp
--inner join RO_CompanyInfo rc on rp.CompanyID = rc.ID
select * from RO_PointScheme 
end

GO
