SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_CounterTransaction_getAllData]
as
SELECT 
ct.CPBalID,ct.Amount,ct.IsOpening,ct.CID
,(select us.Username FROM [dbo].tbl_CTransaction ct
  left join Users us on ct.NCPID=us.UserID where ct.NCPID=us.UserID and convert(date,ct.[Date])=convert(date,GETDATE())) as NewCounterPerson
,(select us.Username FROM [dbo].tbl_CTransaction ct
  left join Users us on ct.OCPID=us.UserID where ct.OCPID=us.UserID and convert(date,ct.[Date])=convert(date,GETDATE())) as OldCounterPerson
--,(select us.Username FROM [dbo].tbl_CTransaction ct left join Users us on ct.NCPID=us.UserID where ct.NCPID=us.UserID) 
	  ,cc.CostCenterName as CCID
  FROM [dbo].tbl_CTransaction ct
 -- left join Users us on ct.NCPID=us.UserID
 -- left join Users uss on ct.OCPID=us.UserID
  left join CostCenterInfo cc on cc.CostCenterId=ct.CostCenterID
  where convert(date,ct.[Date])=convert(date,GETDATE())





GO
