SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[usp_L_LaundryType_DeleteLaundryTypeByID]
@id int
as

delete from dbo.L_LaundryType where dbo.L_LaundryType.ID=@id



GO
