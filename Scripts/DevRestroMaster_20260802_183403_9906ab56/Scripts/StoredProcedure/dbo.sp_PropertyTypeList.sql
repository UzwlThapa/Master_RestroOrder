SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_PropertyTypeList]
AS

SELECT
 [PropertyTypeID],
 [Name]
FROM [dbo].[PropertyType]





GO
