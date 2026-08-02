SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_GetLoyalityDiscountByCard]
@CardTypeID int
as
BEGIN
select * from LoyalityCardType where CardTypeID=@CardTypeID 
END

GO
