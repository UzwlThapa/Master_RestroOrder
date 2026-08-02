SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_DeleteLoyalityCardType]
@CardTypeID int
as
BEGIN
Update LoyalityCardType  
set IsArchived= 1, 
ArchivedOn = getdate()
where CardTypeID = @CardTypeID
END



GO
