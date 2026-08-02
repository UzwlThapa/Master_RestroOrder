SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_GetMemberByID] @MembershipID INT
AS
BEGIN

    SELECT [MembershipID],
           [Fname],
           [Lname],
           [Address],
           [City],
           [Country],
           [TelHome],
           [TelWork],
           [TelMobile],
           [Email],
           [Occupation],
           [Company],
           [Birthday],
           [Anniversary],
           [CardNumber],
           [DateOfIssue],
           [DateOfExpire],
           [discount],
           [PAN],
           [IsCustomer],
           [RemainingBalance],
           [UptoNowPaid],
           [IsVat],
           ISNULL(OpeningBalance, 0) OpeningBalance
    FROM dbo.RO_LoyaltyMembership
    WHERE MembershipID = @MembershipID;
END;

GO
