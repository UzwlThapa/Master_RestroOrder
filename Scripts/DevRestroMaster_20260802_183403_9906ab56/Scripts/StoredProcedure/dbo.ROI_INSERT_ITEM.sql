SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ROI_INSERT_ITEM]
(
	@RId int,
	@ITId int,
	@UnitId int,
	@PRate decimal,
	@SRate decimal,
	@ValidFrom nvarchar(256),
	@PostedBy nvarchar(256)
	
	
)
AS
if (@RId = 0)
BEGIN


	INSERT INTO dbo.ROI_ItemRate (ItemID , UnitID, PRate, SRate, ValidFrom, PostedBy, PostedOn) 
 VALUES(@ITId,				  
	@UnitId,				  
	@PRate,					  
	@SRate,					  
	@ValidFrom, @PostedBy, GETDATE())
	End
begin
update dbo.ROI_ItemRate set ItemID=@ITId, UnitId=@UnitId, PRate=@PRate, SRate=@SRate, ValidFrom=@ValidFrom, PostedBy=@PostedBy, PostedOn=GETDATE()
where ItemRateID = @RId
end









GO
