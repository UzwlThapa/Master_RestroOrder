SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[USP_UPDATE_MEMBERSHIP]
(
    @MembershipID INT ,
    @RemainingBalance DECIMAL (16, 2) ,
    @PayAmount DECIMAL (16, 2) ,
    @AddedBy NVARCHAR (256) ,
    @GoodReceivedMainId INT )
AS
    BEGIN
        DECLARE @RemBalance DECIMAL (16, 2);
        SELECT @RemBalance = ISNULL (rlm.RemainingBalance, 0)
        FROM   dbo.RO_LoyaltyMembership AS rlm
        WHERE  MembershipID = @MembershipID;

        SELECT @RemBalance = @RemBalance + ISNULL (@RemainingBalance, 0);

        UPDATE dbo.RO_LoyaltyMembership
        SET    RemainingBalance = @RemBalance
        WHERE  MembershipID = @MembershipID;

        INSERT INTO [dbo].[RO_MemberPay] ( [MemberID] ,
                                           [RemainingAmount] ,
                                           [PayAmount] ,
                                           [AddedOn] ,
                                           [AddedBy] ,
                                           [IsActive] ,
                                           [GoodReceivedMainId] )
        VALUES ( @MembershipID, @RemainingBalance, @PayAmount, GETDATE (), @AddedBy, 1, @GoodReceivedMainId );
    END;

GO
