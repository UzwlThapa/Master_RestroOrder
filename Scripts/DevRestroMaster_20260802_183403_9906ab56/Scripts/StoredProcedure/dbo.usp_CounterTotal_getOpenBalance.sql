SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--[dbo].[usp_CounterTotal_getOpenBalance] 1, 1
--select CONVERT(date, GETDATE()),* from tbl_ROVaultTotal
CREATE PROCEDURE [dbo].[usp_CounterTotal_getOpenBalance] 
@cid int,
@ccid int
as
select distinct(ct.Balance) from tbl_CounterTotal ct where CONVERT(date, ct.[Date])=CONVERT(date, GETDATE()) and ct.IsClosing=0 and ct.CID=@cid and ct.CCID=@ccid

--select * from tbl_CounterTotal




GO
