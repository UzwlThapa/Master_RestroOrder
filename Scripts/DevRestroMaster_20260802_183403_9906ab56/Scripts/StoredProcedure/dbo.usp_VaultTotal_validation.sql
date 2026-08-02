SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_VaultTotal_validation]
as
select * from tbl_ROVaultTotal rvt where CONVERT(date,rvt.[Date])=CONVERT(date,GETDATE()) and rvt.IsClosing=0




GO
