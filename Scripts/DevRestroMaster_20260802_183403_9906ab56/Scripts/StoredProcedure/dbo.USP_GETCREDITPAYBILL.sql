SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_GETCREDITPAYBILL]
    @MemberPayID INT
AS
    SELECT   mp.[MemberPayID] AS MemberPayId ,
             mp.[MemberID] ,
             lm.Fname + ' ' + lm.Lname AS CustomerName ,
             mpm.[PayAmount] ,
             rpm.PaymentMode ,
             mp.[AddedOn] ,
             mp.[AddedBy] ,
             CASE WHEN lm.IsCustomer < 1 THEN 'Vendor'
                  ELSE 'Customer'
             END AS CustType ,
             mp.SettlementAmount ,
             mpm.TransactionNo ,
             cp.ProviderName ,
             mpm.PaymentModeID
    FROM     [dbo].[RO_MemberPay] mp
             INNER JOIN RO_MemberPaymentMode mpm ON mp.MemberPayID = mpm.MemberPayId
             INNER JOIN RO_LoyaltyMembership lm ON lm.MembershipID = mp.MemberID
             INNER JOIN dbo.RO_PaymentModes AS rpm ON rpm.PaymentModeID = mpm.PaymentModeID
             LEFT JOIN RO_CardProvider cp ON cp.ProviderID = mpm.ProviderID
    WHERE    mp.MemberPayID = @MemberPayID
    ORDER BY CustomerName ASC;


GO
