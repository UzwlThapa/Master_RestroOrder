SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  CREATE PROCEDURE [dbo].[USP_RO_getTodayFiscalYr]
  as
  select * from RO_fiscalYear where IsDeleted=0 and GETDATE() between StartDate and EndDate





GO
