SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[usp_L_LaundryMaster_ViewAddedLaundry]

as

select top 1 * from dbo.L_LaundryMaster order by dbo.L_LaundryMaster.ID desc



GO
