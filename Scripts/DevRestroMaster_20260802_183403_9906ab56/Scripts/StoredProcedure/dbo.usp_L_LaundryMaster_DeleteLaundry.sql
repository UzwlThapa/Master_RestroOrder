SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[usp_L_LaundryMaster_DeleteLaundry]
@id int
As

delete from L_LaundryMaster where ID=@id;
delete from L_LaundryDetails where LaundryMasterID=@id;


GO
