SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_GET_MEMBER_CREDIT_BYID]
    @MembershipID INT
AS
    BEGIN
        DECLARE @PaymentModeId INT;
        SELECT @PaymentModeId = rpm.PaymentModeID
        FROM   dbo.RO_PaymentModes AS rpm
        WHERE  rpm.PaymentMode = 'Credit';

        SELECT rlm.Fname + ' ' + rlm.Lname AS NAME ,
               rlm.[Address] ,
               rlm.TelMobile ,
               rlm.CardNumber ,
               CASE WHEN t.MemberPayId IS NULL THEN ISNULL (rlm.OpeningBalance, 0) + ISNULL (rlm.[RemainingBalance], 0)
                    ELSE ISNULL (rlm.[RemainingBalance], 0)
               END AS RemainingBalance ,
               rlm.MembershipID ,
               rlm.IsCustomer ,
               rlm.UptoNowPaid ,
               rlm.PAN ,
               ISNULL (rlm.OpeningBalance, 0) AS OpeningBalance
        FROM   dbo.RO_LoyaltyMembership AS rlm
               OUTER APPLY ( SELECT [rmp].MemberPayId
                             FROM   [dbo].RO_MemberPaymentMode AS [rmp]
                             WHERE  rlm.MembershipID = rmp.MemberID
                             AND    rmp.MemberPayId <> @PaymentModeId ) t
        WHERE  rlm.MembershipID = @MembershipID;
    END;


GO
