SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ROI_INSERT_UNIT]
(
	@RId int,
	@ITId int,
	@UnitId int,
	@PRate money,
	@SRate money,
	@ValidFrom date
	
	
)
AS
if (@RId = 0)
BEGIN
	INSERT INTO dbo.ITEMRate (ITId, UnitId, PRate, SRate, ValidFrom) 
 VALUES(@ITId,				  
	@UnitId,				  
	@PRate,					  
	@SRate,					  
	@ValidFrom)
	End
begin
update dbo.ITEMRate set ITId=@ITId, UnitId=@UnitId, PRate=@PRate, SRate=@SRate, ValidFrom=@ValidFrom
where RId = @RId
end




GO
