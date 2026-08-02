SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:        [Ujjwal Thapa]
-- Create date:   [2024-07-29]
-- Description:   Report for cancelled bills between given dates
-- Change History:
-- Date          Developer       Description
-- ------------  --------------  ---------------------------------
-- [Change Date] [Developer Name] 
-- =============================================
CREATE PROCEDURE [dbo].[USP_CancelledBillREPORTBtoday]
    @startdate   DATETIME,
    @enddate     DATETIME,
    @cancelledby NVARCHAR(250)
AS
    BEGIN
        DECLARE @code VARCHAR(10);

        SET @code =
            (
                SELECT TOP (1)
                       Code
                FROM
                       dbo.RO_CompanyInfo
            );

        SELECT
                CONVERT(VARCHAR(16), om.BillDate, 20) AS BillDate,
                om.NetAmount,
                om.Waiter,
                rt.restrotableTitle,
                rr.restroRoom,
                @code + CONVERT(   NVARCHAR(10),
                            (
                                SELECT
                                    fyName
                                FROM
                                    dbo.RO_fiscalYear fy
                                WHERE
                                    fy.fyId = om.FiscalYearID
                            )
                               ) + '-' + CONVERT(   NVARCHAR(10), (om.InvoiceNo -
                                                                       (
                                                                           SELECT
                                                                               fy.FirstSalesMasterID
                                                                           FROM
                                                                               dbo.RO_fiscalYear fy
                                                                           WHERE
                                                                               fy.fyId = om.FiscalYearID
                                                                       )
                                                                  )
                                                )     AS billNo,
                om.TableId,
                om.salesMasterId,
                om.OrderMasterId,
                om.Reasons,
                om.ArchivedBy,
                om.IsArchived,
                om.ArchivedOn
        FROM
                dbo.RO_SalesMaster om
            INNER JOIN
                dbo.CBMS_BillPostLog   bp
                    ON bp.SalesMasterId = om.salesMasterId
            LEFT JOIN
                dbo.RO_restroTable rt
                    ON rt.restrotableId = om.TableId
            LEFT JOIN
                dbo.RO_RestroRoom      rr
                    ON rr.restroRoomId = om.RoomId
        WHERE
                (CAST(om.BillDate AS DATETIME)
                BETWEEN @startdate AND @enddate
                )
                AND
                    (
                        om.ArchivedBy = @cancelledby
                        OR @cancelledby = ''
                        OR @cancelledby IS NULL
                    )
                AND
                    (
                        ISNULL(om.IsArchived, 0) = 1
                        OR ISNULL(om.BillCancelled, 0) = 1
                    )
        ORDER BY
                BillDate DESC;
    END;

GO
