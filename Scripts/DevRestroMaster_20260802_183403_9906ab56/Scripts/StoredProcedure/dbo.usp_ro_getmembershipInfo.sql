SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_ro_getmembershipInfo]
AS
    BEGIN
        SELECT   MembershipID ,
                 Fname ,
                 Lname ,
                 Address ,
                 City ,
                 Country ,
                 TelHome ,
                 TelWork ,
                 TelMobile ,
                 Email ,
                 Occupation ,
                 Company ,
                 Birthday ,
                 Anniversary ,
                 CardNumber ,
                 DateOfIssue ,
                 DateOfExpire ,
                 discount ,
                 PAN ,
                 IsCustomer ,
                 OpeningBalance ,
                 RemainingBalance ,
                 UptoNowPaid ,
                 IsVat ,
                 FinancialAcId ,
                 AddedBy ,
                 AddedOn ,
                 ArchivedBy ,
                 ArchivedOn ,
                 UpdatedBy ,
                 UpdatedOn ,
                 IsArchived ,
                 ISNULL (ExtraDetail, '') AS ExtraDetail
        FROM     dbo.RO_LoyaltyMembership
        ORDER BY Fname;
    END;




GO
