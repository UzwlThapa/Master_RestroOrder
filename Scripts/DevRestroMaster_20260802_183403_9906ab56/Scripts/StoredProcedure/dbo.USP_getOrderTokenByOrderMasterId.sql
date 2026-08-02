SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_getOrderTokenByOrderMasterId]
    @orderMasterId INT
AS
    SELECT ISNULL (lm.discount, 0) AS discount ,
           ISNULL (lm.TelMobile, '') AS TelMobile ,
           ot.Id ,
           ot.OrderMasterID ,
           ot.CustomerID ,
           ISNULL (lm.Fname + lm.Lname, ot.CustomerName) AS [CustomerName] ,
           ISNULL (lm.TelMobile, ot.Phone) AS [Phone] ,
           ot.TokenNo ,
           ot.AddedBy ,
           ISNULL (lm.Address, ot.Address) AS [Address]
    FROM   dbo.RO_OrderToken ot
           LEFT JOIN dbo.RO_LoyaltyMembership lm ON ot.CustomerID = lm.MembershipID
    WHERE  ot.OrderMasterID = @orderMasterId;

GO
