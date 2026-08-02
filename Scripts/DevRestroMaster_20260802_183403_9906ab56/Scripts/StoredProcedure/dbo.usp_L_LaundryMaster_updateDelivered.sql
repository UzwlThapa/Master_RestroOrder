SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[usp_L_LaundryMaster_updateDelivered] @id INT
AS
UPDATE L_LaundryMaster
SET IsDelivered = ~ IsDelivered
WHERE ID = @id;

DECLARE @status BIT

SET @status = (
		SELECT IsDelivered
		FROM L_LaundryMaster
		WHERE ID = @id
		)

IF (@status = 1)
BEGIN
	UPDATE L_LaundryDetails
	SET IsDelivered = 1
	WHERE LaundryMasterID = @id;
END
ELSE
BEGIN
	UPDATE L_LaundryDetails
	SET IsDelivered = 0
	WHERE LaundryMasterID = @id;
END
		--select * from L_LaundryDetails



GO
