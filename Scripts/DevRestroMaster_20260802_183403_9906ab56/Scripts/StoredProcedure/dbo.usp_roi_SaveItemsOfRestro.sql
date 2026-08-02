SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--[usp_roi_SaveItemsOfRestro] 0,0,"testin26",true,false,"superuser"
CREATE PROCEDURE [dbo].[usp_roi_SaveItemsOfRestro]
    @ITId INT ,
    @PITId INT ,
    @ITName NVARCHAR (250) ,
    @IsMenu BIT ,
    @IsActive BIT ,
    @IsTaxable BIT ,
	@HsCode NVARCHAR(256),
    @AddedBy NVARCHAR (256)
AS
    BEGIN
        SET NOCOUNT ON;
        BEGIN TRY

            IF ( ISNULL (@ITId, 0) = 0 )
                BEGIN
                    IF NOT EXISTS ( SELECT 1
                                    FROM   dbo.ROI_ITEMMain
                                    WHERE  ITName = @ITName
                                    AND    IsCategory = 0
                                    AND    IsArchived = 0 )
                        BEGIN
                            INSERT INTO dbo.ROI_ITEMMain ( PITId ,
                                                           ITName ,
                                                           IsMenu ,
                                                           IsCategory ,
                                                           IsActive ,
														   HsCode,
                                                           AddedBy ,
                                                           AddedOn ,
                                                           IsArchived )
                            VALUES ( @PITId, @ITName, @IsMenu, 0, @IsActive,@HsCode, @AddedBy, GETDATE (), 0 );
                            SELECT @ITId = CAST(SCOPE_IDENTITY () AS INT);
                        END;
                END;
            ELSE
                BEGIN
                    UPDATE dbo.ROI_ITEMMain
                    SET    PITId = @PITId ,
                           ITName = @ITName ,
                           IsMenu = @IsMenu ,
                           IsActive = @IsActive ,
                           UpdatedBy = @AddedBy ,
						   HsCode = @HsCode,
                           UpdatedOn = GETDATE ()
                    WHERE  ITId = @ITId;

                END;

            SELECT @ITId;
        END TRY
        BEGIN CATCH
            IF @@TRANCOUNT > 0
                ROLLBACK TRANSACTION;
            THROW;
        END CATCH;

    END;

GO
