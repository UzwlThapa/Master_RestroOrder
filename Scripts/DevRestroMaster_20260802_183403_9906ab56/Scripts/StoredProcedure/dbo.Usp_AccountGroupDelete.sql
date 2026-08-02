SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Usp_AccountGroupDelete] 
(
	@Id Int  
)

As
		
----***************************************** Validation Begin ********************************************************

----***************************************** Validation End ********************************************************
SET NOCOUNT ON
SET XACT_ABORT ON 
BEGIN TRY
		DELETE FROM AccountGroup WHERE Id = @Id
END TRY
BEGIN CATCH
	IF @@ERROR = 547
	BEGIN
		RAISERROR('Selected Data Cannot Be Deleted, It is already in use',11,1)
        RETURN
	END
    ELSE
    BEGIN
		DECLARE @ERRORMESSAGE VARCHAR(MAX) = ERROR_MESSAGE()
        RAISERROR(@ERRORMESSAGE,11,1)
    END 
END CATCH
SET XACT_ABORT OFF 






GO
