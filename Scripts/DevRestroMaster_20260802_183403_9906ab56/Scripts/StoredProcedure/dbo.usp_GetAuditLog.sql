SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--  [usp_GetAuditLog] '01/07/2014', '16/07/2022', 'superuser'   
--Drop PROCEDURE [dbo].[usp_GetAuditLog]   
CREATE PROCEDURE [dbo].[usp_GetAuditLog]
    @StartDate DATETIME = '2022-01-01',
    @EndDate DATETIME= '2023-01-01',
    @UserName NVARCHAR(256) ='superuser'
AS
DECLARE @code VARCHAR(10);

SET @code =
(
    SELECT TOP (1) Code FROM RO_CompanyInfo
);
SET @EndDate = DATEADD(DAY, 1, @EndDate);

BEGIN
    DECLARE @t1 TABLE
    (
        SalesMasterid INT,
        FiscalYEARID INT,
        ordermasterid INT,
        tableid INT,
        roomid INT,
        [date] DATETIME,
        menu NVARCHAR(MAX),
        OrdrBy NVARCHAR(MAX),
        [Event] NVARCHAR(MAX)
    );

    DECLARE @t TABLE
    (
        SalesMasterid INT,
        FiscalYEARID INT,
        ordermasterid INT,
        tableid INT,
        roomid INT,
        [date] DATETIME,
        menu NVARCHAR(MAX),
        OrdrBy NVARCHAR(256)
    );

    INSERT INTO @t
    SELECT sm.salesMasterId,
           sm.FiscalYearID,
           OM.OrderMasterID,
           OM.TableId,
           OM.RoomId,
           OM.[Date],
           I.ITName,
           OM.UserName
    FROM RO_SalesMaster sm
        INNER JOIN CBMS_BillPostLog cb
            ON sm.salesMasterId = cb.SalesMasterId
        INNER JOIN RO_OrderMasters OM
            ON sm.OrderMasterId = OM.OrderMasterID
        INNER JOIN RO_Order_Detail OD
            ON OM.OrderMasterID = OD.OrderMasterId
               AND OD.IsCancelled <> 1
        INNER JOIN ROI_ITEMMain I
            ON I.ITId = OD.ROI_ItemId
    WHERE OM.UserName = @UserName
          AND OM.Date
          BETWEEN @StartDate AND @EndDate;

    INSERT INTO @t1
    SELECT t.SalesMasterid,
           t.FiscalYEARID,
           t.ordermasterid,
           t.tableid,
           t.roomid,
           MIN(t.[date]) [DateTime],
           STUFF(
                    (
                        SELECT ', ' + menu
                        FROM @t t1
                        WHERE t1.ordermasterid = t.ordermasterid
                        FOR XML PATH(''), TYPE
                    ).value('.', 'varchar(max)'),
                    1,
                    1,
                    ' '
                ) [Menus],
           OrdrBy,
           'Order Items'
    FROM @t t
    GROUP BY t.SalesMasterid,
             t.FiscalYEARID,
             t.ordermasterid,
             t.tableid,
             t.roomid,
             OrdrBy;

    DELETE FROM @t;

    INSERT INTO @t
    SELECT sm.salesMasterId,
           sm.FiscalYearID,
           OM.OrderMasterID,
           OM.TableId,
           OM.RoomId,
           OM.[Date],
           I.ITName,
           OM.UserName
    FROM RO_SalesMaster sm
        INNER JOIN CBMS_BillPostLog cb
            ON sm.salesMasterId = cb.SalesMasterId
        INNER JOIN RO_OrderMasters OM
            ON sm.OrderMasterId = OM.OrderMasterID
        INNER JOIN RO_Order_Detail OD
            ON OM.OrderMasterID = OD.OrderMasterId
               AND OD.IsCancelled = 1
        INNER JOIN ROI_ITEMMain I
            ON I.ITId = OD.ROI_ItemId
    WHERE OM.UserName = @UserName
          AND OM.Date
          BETWEEN @StartDate AND @EndDate;

    INSERT INTO @t1
    SELECT t.SalesMasterid,
           t.FiscalYEARID,
           t.ordermasterid,
           t.tableid,
           t.roomid,
           MIN(t.[date]) [DateTime],
           STUFF(
                    (
                        SELECT ', ' + menu
                        FROM @t t1
                        WHERE t1.ordermasterid = t.ordermasterid
                        FOR XML PATH(''), TYPE
                    ).value('.', 'varchar(max)'),
                    1,
                    1,
                    ' '
                ) [Menus],
           OrdrBy,
           'Cancel Order Items'
    FROM @t t
    GROUP BY t.SalesMasterid,
             t.FiscalYEARID,
             t.ordermasterid,
             t.tableid,
             t.roomid,
             OrdrBy;


    INSERT INTO @t1
    SELECT sm.salesMasterId,
           FiscalYearID,
           OrderMasterId,
           TableId,
           RoomId,
           BillDate,
           'Cost:' + CAST(NetAmount AS VARCHAR(30)),
           AddedBy,
           'Billing '
    FROM RO_SalesMaster sm
        INNER JOIN CBMS_BillPostLog cb
            ON sm.salesMasterId = cb.SalesMasterId
    WHERE (BillDate
          BETWEEN @StartDate AND @EndDate
          )
          AND AddedBy = @UserName;

    INSERT INTO @t1
    SELECT sm.salesMasterId,
           FiscalYearID,
           OrderMasterId,
           TableId,
           RoomId,
           PD.PrintedDate,
           'No Of Print:' + CAST(PD.PrintedNumber AS VARCHAR(4)),
           PrintedBy,
           'Print Bill'
    FROM RO_SalesMaster sm
        INNER JOIN CBMS_BillPostLog cb
            ON sm.salesMasterId = cb.SalesMasterId
        INNER JOIN PrintDetail PD
            ON sm.salesMasterId = PD.PrintBillNo
    WHERE PrintDate
          BETWEEN @StartDate AND @EndDate
          AND PrintedBy = @UserName;

    INSERT INTO @t1
    SELECT sm.salesMasterId,
           FiscalYearID,
           OrderMasterId,
           TableId,
           RoomId,
           ArchivedOn,
           'Reasons:' + Reasons,
           ArchivedBy,
           'Bill cancel'
    FROM RO_SalesMaster sm
        INNER JOIN CBMS_BillPostLog cb
            ON sm.salesMasterId = cb.SalesMasterId
    WHERE (ArchivedOn
          BETWEEN @StartDate AND @EndDate
          )
          AND ArchivedBy = @UserName
          AND IsArchived = 1;

    INSERT INTO @t1
    SELECT NULL,
           NULL,
           NULL,
           NULL,
           NULL,
           IR.AddedOn,
           'Rate of ' + IM.ITName + ' is set to RS.' + CAST(IR.Rate AS NVARCHAR(256)),
           IR.AddedBy,
           'Item Rate Update'
    FROM ROI_ItemRateHistory IR
        INNER JOIN ROI_ITEMMain IM
            ON IM.ITId = IR.ItemID
               AND IR.IsCombo = 0
    WHERE (IR.AddedOn
          BETWEEN @StartDate AND @EndDate
          )
          AND IR.AddedBy = @UserName
    UNION
    SELECT NULL,
           NULL,
           NULL,
           NULL,
           NULL,
           IR.AddedOn,
           'Rate of ' + IM.Name + ' is set to RS.' + CAST(IR.Rate AS NVARCHAR(256)),
           IR.AddedBy,
           'Item Rate Update'
    FROM ROI_ItemRateHistory IR
        INNER JOIN RO_Combo IM
            ON IM.ComboID = IR.ItemID
               AND IR.IsCombo = 1
    WHERE (IR.AddedOn
          BETWEEN @StartDate AND @EndDate
          )
          AND IR.AddedBy = @UserName;


    INSERT INTO @t1
    SELECT NULL,
           NULL,
           NULL,
           NULL,
           NULL,
           IR.OperationTime,
           CASE
               WHEN IR.Operation = 'R' THEN
                   'Database restore from ' + IR.FileNameAndPath
               WHEN IR.Operation = 'B' THEN
                   'Database backup from ' + IR.FileNameAndPath
           END,
           IR.OperationBy,
           'Database Backup And Restore'
    FROM DBLog IR
    WHERE (IR.OperationTime
          BETWEEN @StartDate AND @EndDate
          )
          AND IR.OperationBy = @UserName;

    SELECT CASE
               WHEN t.SalesMasterid <> 0 THEN
                   @code + fy.fyName + '-' + CAST(sm.InvoiceNo AS VARCHAR(20))
               ELSE
                   ''
           END AS Bill_No,
           t.ordermasterid,
           t.date,
           t.OrdrBy UserName,
           t.Event,
           rt.restrotableTitle,
           rmt.Title RoomType,
           menu [Description]
    FROM @t1 t
        LEFT JOIN RO_SalesMaster sm
            ON sm.salesMasterId = t.SalesMasterid
        LEFT JOIN CBMS_BillPostLog cb
            ON sm.salesMasterId = cb.SalesMasterId
        --left join RO_OrderMasters om on t.ordermasterid = om.OrderMasterID 
        LEFT JOIN RO_fiscalYear fy
            ON t.FiscalYEARID = fy.fyId
        LEFT JOIN RO_restroTable rt
            ON rt.restrotableId = t.tableid
        LEFT JOIN Ro_RoomType rmt
            ON rmt.RoomTypeID = t.roomid
    ORDER BY date;
END;


GO
