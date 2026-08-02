SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_DELETESTORE]
--@text nvarchar(1000) OUTPUT,
@STId INT,
@UserName nvarchar(256)
AS
BEGIN
declare @PSTId int
declare @text nvarchar(100)
Select @PSTId = count(*) From ROI_Store Where PSTId = @STId and IsDeleted!=1

If exists(SELECT storeid store FROM dbo.CostCenterInfo where StoreId = @STId)
BEGIN
set @text='This Store cannot be deleted' 
select @text as text
END
ELSE
IF @PSTId = 0
begin
	Update ROI_Store set IsDeleted = 1, DeletedOn = getdate(),DeletedBy = @UserName WHERE STId =@STId 
	--and PSTId!=@STId
	set @text='Successfully Deleted' 
	select @text as text
end
else
begin
set @text='This Store cannot be deleted' 
select @text as text
--SELECT @@IDENTITY AS 'Identity';
end
END




GO
