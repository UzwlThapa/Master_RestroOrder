SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--*****************sp_10*********************
CREATE PROCEDURE [dbo].[usp_ac_getVoucharTypeForDropDown]
as
select VoucherTypeID,VoucherName,Prefix from Ac_VoucherType where  IsArchived=0
--*************sp_11*****************



GO
