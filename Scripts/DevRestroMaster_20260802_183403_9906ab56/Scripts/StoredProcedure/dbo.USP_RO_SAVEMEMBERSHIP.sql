SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--DROP PROCEDURE [dbo].[USP_RO_SAVEMEMBERSHIP]
CREATE PROCEDURE [dbo].[USP_RO_SAVEMEMBERSHIP]
(
    @MembershipID INT ,
    @Fname NVARCHAR (256) ,
    @Lname NVARCHAR (256) ,
    @Address NVARCHAR (256) ,
    @City NVARCHAR (256) ,
    @Country NVARCHAR (256) ,
    @TelHome NVARCHAR (256) ,
    @TelWork NVARCHAR (256) ,
    @TelMobile NVARCHAR (256) ,
    @Email NVARCHAR (256) ,
    @Occupation NVARCHAR (256) ,
    @Company NVARCHAR (256) = NULL ,
    @Birthday NVARCHAR (256) = NULL ,
    @Anniversary NVARCHAR (256) = NULL ,
    @CardNumber NVARCHAR (256) = NULL ,
    @DateOfIssue NVARCHAR (256) = NULL ,
    @DateOfExpire NVARCHAR (256) = NULL ,
    @discount DECIMAL (18, 0) = NULL ,
    @PAN NVARCHAR (500) ,
    @IsCustomer BIT ,
    @isvat BIT ,
    @Addedby NVARCHAR (256) ,
    @ExtraDetail VARCHAR (MAX) = NULL ,
    @OpeningBalance DECIMAL (16, 2))
AS
    DECLARE @DateNow DATETIME = GETDATE ();

    IF ( @MembershipID = 0 )
        BEGIN
            DECLARE @financialAcId INT;

            INSERT INTO dbo.Ac_FinancialAc ( Name ,
                                             PFinancialAcID ,
                                             FinancialSysID ,
                                             AddedBy ,
                                             AddedOn ,
                                             IsArchived ,
                                             OpeningBalance )
            VALUES ( @Fname + ' ' + @Lname + ' A/C', CASE WHEN @IsCustomer = 1 THEN 15
                                                          ELSE 41
                                                     END, 2, 'system', GETDATE (), 0, @OpeningBalance );

            SET @financialAcId = CAST(SCOPE_IDENTITY () AS INT);

            INSERT INTO dbo.RO_LoyaltyMembership ( Fname ,
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
                                                   RemainingBalance ,
                                                   IsVat ,
                                                   AddedBy ,
                                                   AddedOn ,
                                                   FinancialAcId ,
                                                   OpeningBalance ,
                                                   ExtraDetail )
            VALUES ( @Fname, @Lname, @Address, @City, @Country, @TelHome, @TelWork, @TelMobile, @Email, @Occupation ,
                     @Company , @Birthday, @Anniversary, @CardNumber, @DateOfIssue, @DateOfExpire, @discount, @PAN ,
                     @IsCustomer , 0, @isvat, @Addedby, GETDATE (), @financialAcId, @OpeningBalance, @ExtraDetail );
            SET @MembershipID = CAST(SCOPE_IDENTITY () AS INT);


            EXEC [dbo].[USP_Ac_AddACLoyaltyOpeningBalance] @MembershipId = @MembershipID ,
                                                           @AcId = @financialAcId ,
                                                           @OpeningDate = @DateNow ,
                                                           @OpeningAmt = @OpeningBalance ,
                                                           @AddedBy = @Addedby ,
                                                           @IsDebit = @IsCustomer ,
                                                           @IsAdd = 1;
        END;
    ELSE
        BEGIN
            UPDATE dbo.RO_LoyaltyMembership
            SET    Fname = @Fname ,
                   Lname = @Lname ,
                   Address = @Address ,
                   City = @City ,
                   Country = @Country ,
                   TelHome = @TelHome ,
                   TelWork = @TelWork ,
                   TelMobile = @TelMobile ,
                   Email = @Email ,
                   Occupation = @Occupation ,
                   Company = @Company ,
                   Birthday = @Birthday ,
                   Anniversary = @Anniversary ,
                   CardNumber = @CardNumber ,
                   DateOfIssue = @DateOfIssue ,
                   DateOfExpire = @DateOfExpire ,
                   discount = @discount ,
                   PAN = @PAN ,
                   IsCustomer = @IsCustomer ,
                   IsVat = @isvat ,
                   UpdatedBy = @Addedby ,
                   UpdatedOn = GETDATE () ,
                   OpeningBalance = @OpeningBalance ,
                   ExtraDetail = @ExtraDetail
            WHERE  MembershipID = @MembershipID;

            DECLARE @Fcid INT = ISNULL (( SELECT   TOP ( 1 ) FinancialAcId
                                          FROM     dbo.RO_LoyaltyMembership
                                          WHERE    MembershipID = @MembershipID
                                          ORDER BY MembershipID ) ,
                                        0);


            EXEC [dbo].[USP_Ac_AddACLoyaltyOpeningBalance] @MembershipId = @MembershipID ,
                                                           @AcId = @Fcid ,
                                                           @OpeningDate = @DateNow ,
                                                           @OpeningAmt = @OpeningBalance ,
                                                           @AddedBy = @Addedby ,
                                                           @IsDebit = @IsCustomer ,
                                                           @IsAdd = 0;
        END;



GO
