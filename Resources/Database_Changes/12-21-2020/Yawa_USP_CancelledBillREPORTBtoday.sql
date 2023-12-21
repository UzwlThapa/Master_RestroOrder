SET QUOTED_IDENTIFIER ON;
SET ANSI_NULLS ON;
GO

ALTER PROCEDURE [dbo].[USP_CancelledBillREPORTBtoday]
    @startdate DATETIME ,
    @enddate DATETIME ,
    @cancelledby NVARCHAR (250)
AS
    BEGIN
        DECLARE @code VARCHAR (10);

        SET @code = ( SELECT TOP ( 1 ) Code
                      FROM   RO_CompanyInfo );

        SELECT   CAST(CONVERT (VARCHAR (16), om.BillDate, 20) AS VARCHAR (120)) AS BillDate ,
                 om.NetAmount ,
                 om.Waiter ,
                 rt.restrotableTitle ,
                 rr.restroRoom ,
                 @code + CONVERT (NVARCHAR (10) ,
                         ( SELECT fyName
                           FROM   dbo.RO_fiscalYear fy
                           WHERE  fy.fyId = om.FiscalYearID )) + '-'
                 + CONVERT (NVARCHAR (10) ,
                            ( om.InvoiceNo - ( SELECT fy.FirstSalesMasterID
                                               FROM   dbo.RO_fiscalYear fy
                                               WHERE  fy.fyId = om.FiscalYearID ))) AS billNo ,
                 om.TableId ,
                 om.salesMasterId ,
                 om.OrderMasterId ,
                 --,om.PrintCount
                 om.Reasons ,
                 om.ArchivedBy ,
                 om.IsArchived ,
                 --,cast(om.ArchivedOn as Date) as ArchivedOn
                 om.ArchivedOn
        FROM     dbo.RO_SalesMaster om
                 INNER JOIN CBMS_BillPostLog bp ON bp.SalesMasterId = om.salesMasterId
                 LEFT JOIN dbo.RO_restroTable rt ON rt.restrotableId = om.TableId
                 LEFT JOIN RO_RestroRoom rr ON rr.restroRoomId = om.RoomId
        WHERE --cast(om.ArchivedOn as Date)=@startdate 
                 ( om.BillDate BETWEEN @startdate AND @enddate )
        AND      ( om.ArchivedBy = @cancelledby
                OR @cancelledby = ''
                OR @cancelledby IS NULL )
        OR       ISNULL (om.IsArchived, 0) = 1
        OR       ISNULL (om.BillCancelled, 0) = 1
        ORDER BY BillDate DESC;
    -- where CONVERT(date,om.BillDate)=CONVERT(DATE,getdate())
    END;
--select *  from dbo.RO_SalesMaster om left join dbo.RO_restroTable rt on rt.restrotableId = om.TableId left join RO_RestroRoom rr on rr.restroRoomId=om.RoomId

GO

