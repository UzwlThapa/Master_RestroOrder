SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--DROP proc [dbo].[usp_GetCustomerBalanceByID] 0
CREATE PROCEDURE [dbo].[usp_GetCustomerBalanceByID]
    @IsCustomer INT
AS
    DECLARE @PaymentModeId INT;
    SELECT @PaymentModeId = rpm.PaymentModeID
    FROM   dbo.RO_PaymentModes AS rpm
    WHERE  rpm.PaymentMode = 'Credit';

    SELECT   DISTINCT rlm.[MembershipID] ,
                      rlm.[Fname] ,
                      rlm.[Lname] ,
                      rlm.[Address] ,
                      rlm.[City] ,
                      rlm.[Country] ,
                      rlm.[TelHome] ,
                      rlm.[TelWork] ,
                      rlm.[TelMobile] ,
                      rlm.[CardNumber] ,
                      rlm.[DateOfIssue] ,
                      rlm.[DateOfExpire] ,
                      rlm.[PAN] ,
                      CASE WHEN t.MemberPayId IS NULL THEN
                               ISNULL (rlm.OpeningBalance, 0) + ISNULL (rlm.[RemainingBalance], 0)
                           ELSE ISNULL (rlm.[RemainingBalance], 0)
                      END AS RemainingBalance ,
                      ISNULL (OpeningBalance, 0) AS OpeningBalance
    FROM     [dbo].[RO_LoyaltyMembership] AS [rlm]
             OUTER APPLY ( SELECT [rmp].MemberPayId
                           FROM   [dbo].RO_MemberPaymentMode AS [rmp]
                           WHERE  rlm.MembershipID = rmp.MemberID
                           AND    rmp.MemberPayId <> @PaymentModeId ) t
    WHERE    rlm.IsCustomer = @IsCustomer
    AND      CASE WHEN t.MemberPayId IS NULL THEN ISNULL (rlm.OpeningBalance, 0) + ISNULL (rlm.[RemainingBalance], 0)
                  ELSE ISNULL (rlm.[RemainingBalance], 0)
             END <> 0
    AND      ISNULL (rlm.IsArchived, 0) <> 1
    ORDER BY rlm.Fname;



GO
