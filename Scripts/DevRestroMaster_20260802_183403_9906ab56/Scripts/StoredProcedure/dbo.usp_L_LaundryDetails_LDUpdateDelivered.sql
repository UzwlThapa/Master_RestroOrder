SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[usp_L_LaundryDetails_LDUpdateDelivered]
@id int
As

update L_LaundryDetails 
set IsDelivered=~IsDelivered
where ID=@id;

DECLARE @lmid int,@status BIT
SET @lmid=(Select LaundryMasterID from L_LaundryDetails where ID=@id)
SET @status = (
		SELECT Count(*)
		FROM L_LaundryDetails
		WHERE LaundryMasterID= @lmid AND IsDelivered=0
		)

IF (@status > 0)
BEGIN
	UPDATE L_LaundryMaster
	SET IsDelivered = 0
	WHERE ID = @lmid;
END
ELSE
BEGIN
	UPDATE L_LaundryMaster
	SET IsDelivered = 1
	WHERE ID = @lmid;;
END



GO
