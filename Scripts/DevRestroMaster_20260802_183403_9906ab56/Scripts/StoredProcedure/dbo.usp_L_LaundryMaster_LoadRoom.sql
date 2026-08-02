SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[usp_L_LaundryMaster_LoadRoom]

as

select * from dbo.RO_restroTable where dbo.RO_restroTable.IsTable=1


GO
