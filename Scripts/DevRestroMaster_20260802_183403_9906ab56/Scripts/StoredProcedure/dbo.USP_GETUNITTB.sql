SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[USP_GETUNITTB]
AS
BEGIN

select * from [dbo].[FGetUnitTB]() where Conversion>1

END










GO
