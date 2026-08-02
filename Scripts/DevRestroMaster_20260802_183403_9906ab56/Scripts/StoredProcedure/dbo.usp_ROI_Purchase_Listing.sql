SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_ROI_Purchase_Listing]
    @StartDate NVARCHAR (100) ,
    @EndDate NVARCHAR (100)
AS
    BEGIN


        IF @StartDate = ''
            BEGIN
                SET @StartDate = GETDATE ();
            END;

        IF ( @EndDate = '' )
            BEGIN
                SET @EndDate = GETDATE ();
            END;

        SELECT   dbm.PurchaseMainID ,
                 dbm.PuNo ,
                 FORMAT (dbm.PbDate, 'yyyy-MM-dd') AS PbDate ,
                 dbm.IvNo ,
                 dbm.Vid ,
                 dbm.Remarks ,
                 dbm.FyId ,
                 FORMAT (CAST(dbm.PostedOn AS DATETIME), 'yyyy-MM-dd hh:mm tt') AS PostedOn ,
                 dbm.PostedBy ,
                 dbm.SPMID ,
                 dblm.Fname ,
                 dblm.Lname ,
                 ISNULL (dbm.Vid, 0) AS vender ,
                 ISNULL (COUNT (grd.GDId), 0) AS GoodReceived ,
                 ISNULL (dblm.IsVat, 0) AS IsVat
        FROM     dbo.ROI_PurchaseMain dbm
                 LEFT JOIN dbo.RO_LoyaltyMembership dblm ON dbm.Vid = dblm.MembershipID
                 LEFT JOIN dbo.ROI_PurchaseDetails rpd ON rpd.PurchaseMainID = dbm.PurchaseMainID
                 LEFT JOIN dbo.RO_GoodsReceivedDetls grd ON grd.PDId = rpd.PurchaseDetailsID
        WHERE    CAST(dbm.PbDate AS DATE) BETWEEN CAST(@StartDate AS DATE) AND CAST(@EndDate AS DATE)
        GROUP BY dbm.PurchaseMainID ,
                 dbm.PuNo ,
                 dbm.PbDate ,
                 dbm.IvNo ,
                 dbm.FyId ,
                 dbm.Remarks ,
                 dbm.PostedOn ,
                 dbm.PostedBy ,
                 dbm.SPMID ,
                 dblm.Fname ,
                 dblm.Lname ,
                 dbm.Vid ,
                 dblm.IsVat
        ORDER BY dbm.PurchaseMainID DESC;
    END;

GO
