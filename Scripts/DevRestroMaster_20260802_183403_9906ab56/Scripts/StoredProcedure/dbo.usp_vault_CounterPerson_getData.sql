SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_vault_CounterPerson_getData]
as
SELECT [CPID]
      ,[CPName]
      ,[CPCode]
  FROM [dbo].[tblCounterPerson]





GO
