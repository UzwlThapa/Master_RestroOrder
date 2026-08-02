SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[getActiveBillTerm]
AS
SELECT BilingID
	,NAME
	,Rate
	,[Description]
	,IsAdd
	,SequenceOrder
FROM RO_BillTerm
WHERE Rate <> 0
ORDER BY SequenceOrder ASC




GO
