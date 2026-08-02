SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[USP_RO_deleteBillingTermDetails]
@billtermId int
as

delete from dbo.RO_BillTermDetails where BilingID=@billtermId





GO
