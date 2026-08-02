SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_DoesopeningExistOfCounterTotal]
@CCID int,
@CID int
as
select * from tbl_CounterTotal rvt left join tbl_Roi_Data rda on rvt.CTID=rda.CTID  where IsClosing=0 and convert(date,[Date])=CONVERT(date,GETDATE()) and CCID=@CCID and CID=@CID




GO
