SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Usp_AccountSubGroupDelete] 
(
	@Id Int  
)

As
		
----***************************************** Validation Begin ********************************************************

----***************************************** Validation End ********************************************************
SET NOCOUNT ON
BEGIN TRY
	   DELETE FROM AccountSubGroup WHERE Id = @Id
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






GO
