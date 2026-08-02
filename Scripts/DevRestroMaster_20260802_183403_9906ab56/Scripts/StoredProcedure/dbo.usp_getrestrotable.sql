SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_getrestrotable]
AS
BEGIN
	SELECT * FROM dbo.RO_restroTable order by restrotableTitle
END	




GO
