SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_AC_deleteVoucherTypeByID] 
@VoucherTypeID INT
	,@ArchivedBy NVARCHAR(256)
AS
If exists(select * from Ac_Transaction where  VoucherTypeID=@VoucherTypeID)
BEGIN
select 100 as ErrorNumber 
END
else If exists(select * from Ac_TempTransaction where  VoucherTypeID=@VoucherTypeID and IsDeleted=0)
BEGIN 
select 100 as ErrorNumber
END
ELSE
BEGIN
UPDATE Ac_VoucherType
SET [IsArchived] = 1
	,[ArchivedBy] = @ArchivedBy
	,[ArchivedOn] = GETDATE()
WHERE [VoucherTypeID] = @VoucherTypeID

select 200 as ErrorNumber
END 




GO
