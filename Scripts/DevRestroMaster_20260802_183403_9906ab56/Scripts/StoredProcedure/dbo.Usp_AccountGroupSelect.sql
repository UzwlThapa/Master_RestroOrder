SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Usp_AccountGroupSelect] 
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
	[Type],
	Schedule 
FROM AccountGroup WHERE  Id = @Id 






GO
