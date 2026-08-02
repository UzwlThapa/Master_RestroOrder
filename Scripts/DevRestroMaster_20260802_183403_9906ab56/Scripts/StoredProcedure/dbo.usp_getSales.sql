SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_getSales]
@varible varchar(100),
@Value varchar(100)
as
BEGIN
exec('select * from RO_SalesMaster where '+@varible+'='''+@Value+'''')
END

GO
