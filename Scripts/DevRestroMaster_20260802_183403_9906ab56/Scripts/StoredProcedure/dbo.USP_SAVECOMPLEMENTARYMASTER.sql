SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_SAVECOMPLEMENTARYMASTER]
(
    @CompMasterID INT ,
    @TableId NVARCHAR (50) ,
    @BillNo NVARCHAR (128) ,
    @Date DATETIME ,
    @IsCancelled BIT ,
    @BasicAmount DECIMAL ,
    @TermAmount DECIMAL (18, 2) ,
    @NetAmount DECIMAL (18, 2) ,
    @UserName NVARCHAR (128) ,
    @Remarks NVARCHAR (512) ,
    @IsSplit BIT ,
    @GuestNo INT ,
    @BillPaid INT ,
    @RoomId INT ,
    @OID INT ,
    @OrderStatus INT ,
    @Details NVARCHAR (MAX))
AS
    IF ( @CompMasterID = 0 )
        BEGIN
            DECLARE @val INT;
            INSERT INTO dbo.tblComplementaryMaster ( TableId ,
                                                     BillNo ,
                                                     Date ,
                                                     IsCancelled ,
                                                     BasicAmount ,
                                                     TermAmount ,
                                                     NetAmount ,
                                                     UserName ,
                                                     Remarks ,
                                                     IsSplit ,
                                                     GuestNo ,
                                                     BillPaid ,
                                                     RoomId ,
                                                     OID ,
                                                     OrderStatus ,
                                                     IsPrinted ,
                                                     Details )
            VALUES ( @TableId, @BillNo, @Date, @IsCancelled, @BasicAmount, @TermAmount, @NetAmount, @UserName ,
                     @Remarks , @IsSplit, @GuestNo, @BillPaid, @RoomId, @OID, 0, 0, @Details );

            SELECT SCOPE_IDENTITY ();
        END;
    ELSE
        BEGIN
            UPDATE dbo.tblComplementaryMaster
            SET    TableId = @TableId ,
                   BillNo = @BillNo ,
                   IsCancelled = @IsCancelled ,
                   BasicAmount = @BasicAmount ,
                   TermAmount = @TermAmount ,
                   NetAmount = @NetAmount ,
                   UserName = @UserName ,
                   Remarks = @Remarks ,
                   IsSplit = @IsSplit ,
                   GuestNo = @GuestNo ,
                   BillPaid = @BillPaid ,
                   RoomId = @RoomId ,
                   OID = @OID ,
                   @OrderStatus = 1 ,
                   Details = @Details
            WHERE  CompMasterID = @CompMasterID;
        END;

GO
