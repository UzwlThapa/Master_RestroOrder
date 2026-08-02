SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[usp_L_LaundryRate_DeleteLaundryRate]
@id int
as

delete from dbo.L_LaundryRate
where dbo.L_LaundryRate.ID = @id



GO
