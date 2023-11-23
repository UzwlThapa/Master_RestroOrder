SET QUOTED_IDENTIFIER ON;
SET ANSI_NULLS ON;
GO
/*
====================================
	Author: Unknown
    Creadted Date: Unknown
	Last Modified By: Yawahang
	Last Modified Date: 11/22/2023
====================================

EXEC dbo.usp_roi_SaveItemsOfRestro @ITId = 0 ,        -- int
                              @PITId = 7288 ,       -- int
                              @ITName = N'ROTI SABJI' ,    -- nvarchar(250)
                              @IsMenu = 1 ,   -- bit
                              @IsActive = 1 , -- bit
                              @AddedBy = N'test'     -- nvarchar(256)

*/
ALTER PROCEDURE [dbo].usp_roi_SaveItemsOfRestro
    @ITId INT ,
    @PITId INT ,
    @ITName NVARCHAR (250) ,
    @IsMenu BIT ,
    @IsActive BIT ,
    @AddedBy NVARCHAR (256)
AS
    IF ( @ITId = 0 )
        BEGIN
            IF NOT EXISTS ( SELECT 1
                            FROM   ROI_ITEMMain
                            WHERE  ITName = @ITName
                            AND    IsArchived = 0
                            AND    IsMenu = @IsMenu
                            AND    PITId = @PITId )
                BEGIN
                    INSERT INTO ROI_ITEMMain ( PITId ,
                                               ITName ,
                                               IsMenu ,
                                               IsCategory ,
                                               IsActive ,
                                               AddedBy ,
                                               AddedOn ,
                                               IsArchived )
                    VALUES ( @PITId, @ITName, @IsMenu, 0, @IsActive, @AddedBy, GETDATE (), 0 );
                    SELECT CAST(@@IDENTITY AS INT);
                END;
        END;
    ELSE
        BEGIN
            UPDATE ROI_ITEMMain
            SET    PITId = @PITId ,
                   ITName = @ITName ,
                   IsMenu = @IsMenu ,
                   IsActive = @IsActive ,
                   UpdatedBy = @AddedBy ,
                   UpdatedOn = GETDATE ()
            WHERE  ITId = @ITId;

            SELECT CAST(@ITId AS INT);
        END;



GO

