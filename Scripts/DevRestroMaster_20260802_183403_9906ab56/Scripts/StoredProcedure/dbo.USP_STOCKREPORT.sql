SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--exec [dbo].[USP_STOCKREPORT] '2024-07-02 19:48:16.837'
CREATE PROCEDURE [dbo].[USP_STOCKREPORT]
    @Todaydate DATETIME
AS
    BEGIN

        SELECT   IM.ITName ,
                 ib.OPBal ,
                 ib.CLBal ,
                 RS.StName ,
                 CAST (ExpDate AS VARCHAR (12)) AS ExpDate ,
                 CAST (ib.PostedDate AS VARCHAR (12)) AS PbDate ,
                 *
        FROM     dbo.ROI_ITEMBal ib
                 INNER JOIN dbo.ROI_ITEMMain IM ON ib.ITId = IM.ITId
                 INNER JOIN dbo.ROI_Store RS ON RS.STId = ib.STId
                 INNER JOIN dbo.ROI_PurchaseLotNo pl ON ib.PDId = pl.PurchaseDetailsID
        WHERE    CAST (ib.PostedDate AS DATE) = @Todaydate
        ORDER BY IM.ITName;
    END;





GO
