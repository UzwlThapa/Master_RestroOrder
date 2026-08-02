SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_ro_getRONumberByFiscalYear]
AS
SELECT * FROM [dbo].[RO_fiscalYear] WHERE isActive=1




GO
