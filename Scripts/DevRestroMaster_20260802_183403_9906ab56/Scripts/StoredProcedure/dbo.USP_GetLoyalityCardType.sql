SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_GetLoyalityCardType]
as
BEGIN
select * from LoyalityCardType where IsArchived<>1 
END

GO
