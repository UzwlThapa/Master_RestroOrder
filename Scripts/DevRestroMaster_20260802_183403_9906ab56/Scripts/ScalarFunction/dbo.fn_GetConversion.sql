SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

Create FUNCTION [dbo].[fn_GetConversion] 
(
	@largeUnit int
	,@smallUnit int
)
RETURNS int
AS
BEGIN
Declare @conversion int
	select @conversion=Conversion from ROI_Unit2 u
	where u.FirstUnit=@largeUnit and u.SecondUnit=@smallUnit

	return @conversion

	
END
--select max(m.OrderMasterID) from RO_OrderMasters m where m.tableId=0







GO
