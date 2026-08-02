SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Script for SelectTopNRows command from SSMS  ******/
CREATE PROCEDURE [dbo].[usp_ro_GetFiscalYear]
AS
BEGIN
	SELECT [fyId]
		,[fyName]
		,[isActive]
		,[StartDate]
		,[EndDate]
		,[AddedBy]
		,[AddedOn]
		,[UpdatedBy]
		,[UpdatedOn]
		,[IsDeleted]
	FROM [RO_fiscalYear]
END





GO
