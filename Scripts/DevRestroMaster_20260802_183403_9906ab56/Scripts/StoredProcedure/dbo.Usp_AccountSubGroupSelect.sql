SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Usp_AccountSubGroupSelect] 
(
	@Id Int  
)

As
		
----***************************************** Validation Begin ********************************************************

----***************************************** Validation End ********************************************************
SET NOCOUNT ON
SELECT 
	Id, 
	Code, 
	Name, 
	AccountGroupId
FROM AccountSubGroup 
WHERE  Id = @Id  






GO
