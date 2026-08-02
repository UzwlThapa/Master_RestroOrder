SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_ROI_SAVESTORE]
@storeId int,
@storeName varchar(128),
@ParentStoreId int
as
begin
	if(@storeId=0)
	begin
	insert into ROI_Store(StName, PSTId) values(@storeName, @ParentStoreId)
	end
	else
	begin
		update ROI_Store set
		StName=@storeName,
		PSTId = @ParentStoreId
		where STId=@storeId
	end
end




GO
