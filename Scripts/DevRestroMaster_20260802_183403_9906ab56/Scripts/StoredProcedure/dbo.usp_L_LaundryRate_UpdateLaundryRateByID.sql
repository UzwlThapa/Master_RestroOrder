SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[usp_L_LaundryRate_UpdateLaundryRateByID]
@id int,
@clothid int,
@laundryTypeId int,
@rate decimal(18,0)
as

update dbo.L_LaundryRate set dbo.L_LaundryRate.ClothTypeID=@clothid,dbo.L_LaundryRate.LaundryTypeID=@laundryTypeId,dbo.L_LaundryRate.Rate=@rate
where dbo.L_LaundryRate.ID = @id



GO
