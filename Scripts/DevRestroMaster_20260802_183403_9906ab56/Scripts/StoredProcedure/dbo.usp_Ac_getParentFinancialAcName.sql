SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--***************sp-1***************
CREATE PROCEDURE [dbo].[usp_Ac_getParentFinancialAcName]  
as  
select FinancialAcID,Name as FinancialAcName from Ac_FinancialAc where IsArchived=0  



GO
