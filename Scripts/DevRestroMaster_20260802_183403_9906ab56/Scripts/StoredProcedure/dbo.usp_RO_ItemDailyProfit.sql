SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- drop Procedure usp_RO_ItemDailyProfit '2019-01-06 0:0' , '2019-01-06 23:59' , 0
CREATE PROCEDURE [dbo].[usp_RO_ItemDailyProfit]
    @startDate DATETIME,
    @endDate DATETIME,
    @itemId INT
AS
BEGIN
    IF (OBJECT_ID('tempdb..#TempIngrediants') IS NOT NULL)
        DROP TABLE #TempIngrediants;
    IF (OBJECT_ID('tempdb..#temp') IS NOT NULL)
        DROP TABLE #temp;

    SELECT im.ITId,
           im.ITName,
           id.SmallUnit,
           u.Symbol,
           ISNULL(gd.Rate, 0) / ISNULL(dbo.[fn_GetConversion](pd.UsedUnitID, id.SmallUnit), 1) AS SmallUnitRate
    INTO #TempIngrediants
    FROM ROI_ITEMMain im
        INNER JOIN ROI_ItemDetails id
            ON id.ITId = im.ITId
               AND im.IsCategory = 0
               AND im.IsMenu = 0
               AND im.IsArchived = 0
        LEFT JOIN
        (
            SELECT pd.ItemID,
                   MAX(gd.GDId) AS [MAXGDId]
            FROM RO_GoodsReceivedDetls gd
                INNER JOIN ROI_PurchaseDetails pd
                    ON pd.PurchaseDetailsID = gd.PDId
            WHERE gd.Rate IS NOT NULL
            GROUP BY ItemID
        ) x
            ON x.ItemID = im.ITId
        LEFT JOIN RO_GoodsReceivedDetls gd
            ON x.MAXGDId = gd.GDId
        LEFT JOIN ROI_PurchaseDetails pd
            ON pd.PurchaseDetailsID = gd.PDId
        INNER JOIN ROI_Unit1 u
            ON u.Unit1Id = id.SmallUnit
    WHERE im.IsArchived = 0;

    SELECT m.ITId AS ItemID,
           m.ITName AS ItemName,
           ri.Ingredient AS Ingredient,
           ISNULL(ri.Quantity, 0) AS Quantity,
           ISNULL((i.ITName + ', ' + i.Symbol + ' / ' + u1.Symbol), '-, ') AS IngredientName,
           --,cast(isnull( i.SmallUnitRate,0)as decimal(10,2))  AS Amount
           ISNULL(ri.Quantity, 0) * CAST(ISNULL(i.SmallUnitRate, 0) AS DECIMAL(10, 2)) AS Amount
    INTO #temp
    FROM ROI_ITEMMain m
        INNER JOIN ROI_ItemDetails d
            ON m.ITId = d.ITId
        LEFT JOIN ROI_Unit1 u1
            ON u1.Unit1Id = d.SmallUnit
        LEFT JOIN Ro_Ingredient ri
            ON ri.ItemID = m.ITId
        LEFT JOIN #TempIngrediants i
            ON ri.Ingredient = i.ITId
    WHERE m.IsActive = 1
          AND m.IsArchived = 0
          AND d.IsProdMaterial = 0
          AND m.IsCategory = 0
          AND m.IsMenu = 1
    ORDER BY m.ITName;
    --select * from #temp

    --select
    --m.ItemID,
    --ItemName,
    --SUM(m.AMOUNT) as ItemCost,
    --r.SRate AS MRP
    --, SUM(sd.qty) as Quantity
    --,(SUM(m.AMOUNT) * SUM(sd.qty)) as TotalCost
    --,(r.SRate * SUM(sd.qty)) as TotalSales
    --,((r.SRate * SUM(sd.qty)) - (SUM(m.AMOUNT) * SUM(sd.qty))) as Profit
    --from #temp m
    --INNER JOIN ROI_ItemRate r ON m.ItemID = r.ItemID
    --Inner JOin RO_SalesDetail sd on sd.ItemId = m.ItemID
    --inner join RO_SalesMaster sm on sd.salesMasterId = sm.salesMasterId
    --WHERE (
    --sm.BillDate BETWEEN dateadd(hour, 4, @startDate)
    --AND dateadd(hour, 4, @endDate)
    --)
    --AND (sd.ItemId = @itemId or @ItemId = 0 )
    --And sm.IsArchived =0
    --GROUP BY m.ItemID, ItemName, r.SRate
    --order by ItemName

    -- Modified By Sunil Nepali
    --Logic Changed
    WITH cte
    AS (SELECT sd.ItemId,
               a.ItemName,
               a.Amount AS ItemCost,
               SUM(qty) AS Quantity,
               r.SRate
        FROM RO_SalesDetail sd
            INNER JOIN RO_SalesMaster sm
                ON sd.salesMasterId = sm.salesMasterId
            INNER JOIN
            (
                SELECT ItemID,
                       ItemName,
                       SUM(Amount) AS Amount
                FROM #temp
                --where ItemName='MUSTANG CHICKEN (HALF)'
                GROUP BY ItemName,
                         ItemID
            ) a
                ON sd.ItemId = a.ItemID
            JOIN ROI_ItemRate r
                ON a.ItemID = r.ItemID
        WHERE (sm.BillDate
              BETWEEN DATEADD(HOUR, 4, @startDate) AND DATEADD(HOUR, 4, @endDate)
              )
              AND
              (
                  sd.ItemId = @itemId
                  OR @itemId = 0
              )
              AND sm.IsArchived = 0
        GROUP BY sd.ItemId,
                 a.Amount,
                 a.ItemName,
                 r.SRate)
    SELECT ItemId,
           ItemName,
           SUM(ItemCost) AS ItemCost,
           SRate AS MRP,
           SUM(Quantity) AS Quantity,
           (SUM(ItemCost) * SUM(Quantity)) AS TotalCost,
           (SRate * SUM(Quantity)) AS TotalSales,
           ((SRate * SUM(Quantity)) - (SUM(ItemCost) * SUM(Quantity))) AS Profit
    FROM cte
    GROUP BY ItemId,
             ItemName,
             SRate;

END;

GO
