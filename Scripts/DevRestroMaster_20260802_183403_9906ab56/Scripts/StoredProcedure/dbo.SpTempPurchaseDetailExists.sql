SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SpTempPurchaseDetailExists]
AS
    BEGIN

        DECLARE @PuNo NVARCHAR (200) = N'';

        SELECT   TOP ( 1 ) @PuNo = rpm.PuNo
        FROM     dbo.ROI_PurchaseMain AS rpm
        WHERE    rpm.PostedBy = 'systemAuto'
        ORDER BY rpm.PbDate DESC;

        SELECT @PuNo;
    END;
GO
