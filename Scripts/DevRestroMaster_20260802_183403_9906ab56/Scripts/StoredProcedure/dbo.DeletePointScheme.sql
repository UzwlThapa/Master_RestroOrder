SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DeletePointScheme]
@CompanyID int
as begin 
Delete RO_PointScheme where CompanyID=@CompanyID
end



GO
