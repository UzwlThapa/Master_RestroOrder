SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_SaveLoyalityCardType]
(
@CardTypeID int
,@CardName nvarchar(250)
,@Description nvarchar(MAX)
,@discount decimal(18, 2)
)
AS
IF(@CardTypeID  = 0 )

INSERT INTO LoyalityCardType
(
CardName
,Description
,discount
,AddedOn
,IsArchived
)
values
(
@CardName
,@Description
,@discount
,getdate()
,0
)

ELSE

UPDATE LoyalityCardType 
SET CardName = @CardName
,Description = @Description
,discount = @discount
where CardTypeID = @CardTypeID

GO
