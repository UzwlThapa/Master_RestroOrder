SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_ac_deleteLaundryDetailByID]
@lmasterid int
as
delete dbo.L_LaundryDetails where LaundryMasterID=@lmasterid

GO
