SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ROI_SAVEPURCHASEMAIN]
    @PurchaseMainID INT ,
    @PuNo NVARCHAR (200) ,
    @PbDate DATETIME ,
    @IvNo NVARCHAR (200) ,
    @Vid INT ,
    @Remarks NVARCHAR (MAX) ,
    @FyId NVARCHAR (200) ,
    @PostedOn VARCHAR (100) ,
    @PostedBy NVARCHAR (100) ,
    @SPMID INT
AS
    BEGIN
        --DELETE FROM dbo.ROI_PurchaseDetails
        --WHERE PurchaseMainID = @PurchaseMainID;

        --DECLARE @pdID INT;

        --SELECT @pdID = PurchaseDetailsID
        --FROM   dbo.ROI_PurchaseDetails
        --WHERE  PurchaseMainID = @PurchaseMainID;

        --DELETE FROM dbo.ROI_PurchaseLotNo
        --WHERE PurchaseDetailsID = @pdID;

        IF ( @PurchaseMainID = 0 )
            BEGIN
                INSERT INTO dbo.ROI_PurchaseMain ( PuNo ,
                                                   PbDate ,
                                                   IvNo ,
                                                   Vid ,
                                                   Remarks ,
                                                   FyId ,
                                                   PostedOn ,
                                                   PostedBy ,
                                                   SPMID )
                VALUES ( @PuNo, @PbDate, @IvNo, @Vid, @Remarks, @FyId, @PostedOn, @PostedBy, @SPMID );

                SELECT CAST(@@IDENTITY AS INT);
            END;
        ELSE
            BEGIN

                IF EXISTS ( SELECT 1
                            FROM   dbo.ROI_PurchaseMain AS rpm
                            WHERE  rpm.PurchaseMainID = @PurchaseMainID
                            AND    rpm.PostedBy = 'systemAuto' )
                    BEGIN
                        SELECT @PostedBy = 'systemAuto';
                    END;

                UPDATE dbo.ROI_PurchaseMain
                SET    PuNo = @PuNo ,
                       PbDate = @PbDate ,
                       IvNo = @IvNo ,
                       Vid = @Vid ,
                       Remarks = @Remarks ,
                       FyId = @FyId ,
                       PostedOn = @PostedOn ,
                       PostedBy = @PostedBy ,
                       SPMID = @SPMID
                WHERE  PurchaseMainID = @PurchaseMainID;

                SELECT CAST(@PurchaseMainID AS INT);
            END;
    END;


GO
