SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--DROP PROCEDURE [dbo].[USP_GETMEMBERSHIPFORM]  
CREATE PROCEDURE [dbo].[USP_GETMEMBERSHIPFORM]
    @customer INT
AS
    BEGIN

        SELECT   Fname + ' ' + Lname AS Name ,
                 Address + ' ' + City + ' ' + Country AS Addresss ,
                 [MembershipID] ,
                 [Fname] ,
                 [Lname] ,
                 [Address] ,
                 [City] ,
                 [Country] ,
                 [TelHome] ,
                 [TelWork] ,
                 [TelMobile] ,
                 [Email] ,
                 [Occupation] ,
                 [Company] ,
                 [Birthday] ,
                 [Anniversary] ,
                 [CardNumber] ,
                 [DateOfIssue] ,
                 [DateOfExpire] ,
                 [discount] ,
                 [PAN] ,
                 [IsCustomer] ,
                 [RemainingBalance] ,
                 [UptoNowPaid] ,
                 [IsVat] ,
                 ISNULL (OpeningBalance, 0) AS OpeningBalance ,
                 ISNULL (ExtraDetail, '') AS ExtraDetail
        FROM     dbo.RO_LoyaltyMembership
        WHERE    [IsCustomer] = @customer
        AND      ISNULL (IsArchived, 0) <> 1
        ORDER BY Fname;

    END;



GO
