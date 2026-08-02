SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_SaveItemWithUnit]
    @ItemID INT ,
    @SalesRate DECIMAL (18, 2) ,
    @ValidFrom DATETIME ,
    @AddedBy NVARCHAR (250)
AS
    IF ( ISNULL (@ValidFrom, '') = '' )
        BEGIN
            SELECT @ValidFrom = GETDATE ();
        END;

    IF NOT EXISTS ( SELECT *
                    FROM   dbo.ROI_ItemRate
                    WHERE  ItemID = @ItemID )
        BEGIN
            INSERT INTO dbo.ROI_ItemRate ( ItemID ,
                                           SRate ,
                                           ValidFrom ,
                                           PostedBy ,
                                           PostedOn ,
                                           IsArchived )
                        SELECT @ItemID ,
                               @SalesRate ,
                               @ValidFrom ,
                               @AddedBy ,
                               GETDATE () ,
                               0;


            INSERT INTO [dbo].[ROI_ItemRateHistory] ( [ItemID] ,
                                                      [IsCombo] ,
                                                      [AddedBy] ,
                                                      Operation ,
                                                      Rate )
            VALUES ( @ItemID, 0, @AddedBy, 1, @SalesRate );
        END;
    ELSE
        BEGIN
            UPDATE dbo.ROI_ItemRate
            SET    SRate = @SalesRate ,
                   ValidFrom = @ValidFrom ,
                   UpdatedBy = @AddedBy ,
                   UpdatedOn = GETDATE ()
            WHERE  ItemID = @ItemID;

            INSERT INTO [dbo].[ROI_ItemRateHistory] ( [ItemID] ,
                                                      [IsCombo] ,
                                                      [AddedBy] ,
                                                      Operation ,
                                                      Rate )
            VALUES ( @ItemID, 0, @AddedBy, 2, @SalesRate );
        END;

GO
