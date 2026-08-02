SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_DoesopeningExist]
as
select * from tbl_ROVaultTotal rvt left join tbl_Roi_Data rda on rvt.TotalID=rda.TID  where IsClosing=0 and convert(date,[Date])=CONVERT(date,GETDATE())




GO
