SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_AC_saveVoucherType] @VoucherTypeID INT
	,@VoucherName NVARCHAR(256)
	,@Prefix NVARCHAR(50)
	,@AddedBy NVARCHAR(256)
AS
--DECLARE @VoucherTypeID INT;
--DECLARE @VoucherName NVARCHAR(256);
--DECLARE @Prefix NVARCHAR(50);
IF (@VoucherTypeID = 0)
BEGIN
	INSERT INTO Ac_VoucherType (
		[VoucherName]
		,[Prefix]
		,[AddedBy]
		,[AddedOn]
		)
	VALUES (
		@VoucherName
		,@Prefix
		,@AddedBy
		,GETDATE()
		)
END
ELSE
BEGIN
	UPDATE Ac_VoucherType
	SET [VoucherName] = @VoucherName
		,[Prefix] = @Prefix
		,[UpdatedBy] = @AddedBy
		,[UpdatedOn] = GETDATE()
		,[IsUpdated] = 1
		where [VoucherTypeID]=@VoucherTypeID
END



GO
