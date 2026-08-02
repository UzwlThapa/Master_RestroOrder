SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_AC_getVoucherTypeList]
as
select VoucherTypeID,VoucherName,Prefix from Ac_VoucherType
where IsArchived=0



GO
