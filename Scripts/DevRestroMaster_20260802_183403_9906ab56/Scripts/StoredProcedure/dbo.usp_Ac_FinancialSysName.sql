SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--********************SP-3****************
CREATE PROCEDURE [dbo].[usp_Ac_FinancialSysName]
AS
SELECT FinancialSysID
	,NAME AS FinancialSysName
	,IsGroup
FROM dbo.Ac_FinancialSys



GO
