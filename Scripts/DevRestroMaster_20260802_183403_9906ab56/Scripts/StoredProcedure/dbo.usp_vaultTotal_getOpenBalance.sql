SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--[dbo].[usp_vaultTotal_getOpenBalance] '2016-09-13'
--select CONVERT(date, GETDATE()),* from tbl_ROVaultTotal
CREATE PROCEDURE [dbo].[usp_vaultTotal_getOpenBalance]
as
select distinct(Balance) from tbl_ROVaultTotal where CONVERT(date, [Date])=CONVERT(date, GETDATE()) and IsClosing=0




GO
