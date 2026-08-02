SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[ConvertDateToNepali] (@englishDate NVARCHAR(max))
RETURNS NVARCHAR(max)
AS
BEGIN
	DECLARE @nepaliDate NVARCHAR(max)

	SELECT @nepaliDate = Stuff(Stuff(dm.NpDateInt, Len(dm.NpDateInt) - 1, 0, '.'), Len(dm.NpDateInt) - 3, 0, '.')
	FROM [tbl_DateMap] dm
	WHERE CAST(dm.GregorianDate AS DATE) = CAST(@englishDate AS DATE)

	RETURN @nepaliDate
END

GO
