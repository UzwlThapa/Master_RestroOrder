SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[usp_L_LaundryRate_LoadLaundryTypeList]

as

select dbo.L_LaundryType.ID as LaundryTypeID,dbo.L_LaundryType.Type as LaundryType
from dbo.L_LaundryType



GO
