SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_CounterTotal_getdata]
as
SELECT [CTID]
      ,[Balance]
      ,[IsClosing]
      ,[DifAmount]
      ,[CID]
	  ,us.Username as ApprovedBy
	  ,cc.CostCenterName as CCID
  FROM [dbo].[tbl_CounterTotal] ct
  left join Users us on ct.ApprovedBy=us.UserID
  left join CostCenterInfo cc on cc.CostCenterId=ct.CCID
  where ct.[Date]=convert(date,GETDATE())





GO
