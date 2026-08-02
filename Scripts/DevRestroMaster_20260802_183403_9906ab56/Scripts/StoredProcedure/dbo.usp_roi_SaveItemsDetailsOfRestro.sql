SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_roi_SaveItemsDetailsOfRestro]
    @ITId INT ,
    @ITCode NVARCHAR (250) ,
    @ImagePath NVARCHAR (256) = NULL ,
    @IsExpirable BIT ,
    @IsProdMaterial BIT ,
    @IsUnitWiseRate BIT ,
    @ItemCostCentreID INT ,
    @Details NVARCHAR (MAX) = NULL ,
    @SmallUnit INT ,
    @AddedBy NVARCHAR (250) ,
    @IsExtra BIT
AS
    IF NOT EXISTS ( SELECT 1
                    FROM   dbo.ROI_ItemDetails
                    WHERE  ITId = @ITId )
        BEGIN
            INSERT INTO dbo.ROI_ItemDetails ( ITId ,
                                              ITCode ,
                                              ImagePath ,
                                              IsExpirable ,
                                              IsProdMaterial ,
                                              IsUnitWiseRate ,
                                              ItemCostCentreID ,
                                              Details ,
                                              SmallUnit ,
                                              AddedBy ,
                                              AddedOn ,
                                              IsArchived ,
                                              IsExtra )
                        SELECT @ITId ,
                               @ITCode ,
                               @ImagePath ,
                               @IsExpirable ,
                               @IsProdMaterial ,
                               @IsUnitWiseRate ,
                               @ItemCostCentreID ,
                               @Details ,
                               @SmallUnit ,
                               @AddedBy ,
                               GETDATE () ,
                               0 ,
                               @IsExtra
                        FROM   dbo.ROI_ITEMMain AS rim
                        WHERE  rim.ITId = @ITId;
        END;
    ELSE
        BEGIN
            UPDATE dbo.ROI_ItemDetails
            SET    ITCode = @ITCode ,
                   ImagePath = @ImagePath ,
                   IsExpirable = @IsExpirable ,
                   IsProdMaterial = @IsProdMaterial ,
                   IsUnitWiseRate = @IsUnitWiseRate ,
                   ItemCostCentreID = @ItemCostCentreID ,
                   Details = @Details ,
                   SmallUnit = @SmallUnit ,
                   UpdatedBy = @AddedBy ,
                   UpdatedOn = GETDATE () ,
                   IsExtra = @IsExtra
            WHERE  ITId = @ITId;
        END;

    IF  NOT EXISTS ( SELECT 1
                     FROM   dbo.ROI_ITEMBal
                     WHERE  ITId = @ITId
                     AND    STId = 1 )
    AND @IsProdMaterial = 1
        BEGIN
            INSERT INTO dbo.ROI_ITEMBal ( ITId ,
                                          STId ,
                                          OPBal ,
                                          CLBal ,
                                          PostedDate )
            VALUES ( @ITId, 1, 0, 0, GETDATE ());
        END;

GO
