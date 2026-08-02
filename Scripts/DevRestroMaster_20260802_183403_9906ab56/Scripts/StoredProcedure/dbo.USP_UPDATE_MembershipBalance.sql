SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--DROP PROCEDURE [dbo].[USP_UPDATE_MembershipBalance]
CREATE PROCEDURE [dbo].[USP_UPDATE_MembershipBalance]
(
    @MembershipID INT ,
    @RemainingBalance DECIMAL (16, 2) ,
    @PayAmount DECIMAL (16, 2) ,
    @SettlementAmount DECIMAL (16, 2) ,
    @AddedBy NVARCHAR (256) ,
    @ReturnAmount DECIMAL (16, 2) = 0 )
AS
    BEGIN
        UPDATE dbo.RO_LoyaltyMembership
        SET    RemainingBalance = @RemainingBalance
        WHERE  MembershipID = @MembershipID;

        INSERT INTO [dbo].[RO_MemberPay] ( [MemberID] ,
                                           [RemainingAmount] ,
                                           [PayAmount] ,
                                           [SettlementAmount] ,
                                           [AddedOn] ,
                                           [AddedBy] ,
                                           [IsActive] ,
                                           [ReturnAmount] )
        VALUES ( @MembershipID, @RemainingBalance, @PayAmount, @SettlementAmount, GETDATE (), @AddedBy, 1 ,
                 @ReturnAmount );

        SELECT SCOPE_IDENTITY ();
    END;



GO
