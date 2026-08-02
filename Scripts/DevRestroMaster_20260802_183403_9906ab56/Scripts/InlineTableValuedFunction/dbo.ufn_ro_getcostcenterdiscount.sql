SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   FUNCTION [dbo].[ufn_ro_getcostcenterdiscount]
(
    @SalesMasterId INT
)
RETURNS TABLE
AS
RETURN
(
    SELECT
        SalesMasterId,

        -- KOT
        TRY_CAST(kotdis AS DECIMAL(10, 2)) AS KOTDiscountPercent,
        kotAmt,
        ROUND((TRY_CAST(kotdis AS DECIMAL(10, 2)) / 100.0) * ISNULL(kotAmt, 0), 2) AS KOTDiscount,

        -- Bar
        TRY_CAST(bardis AS DECIMAL(10, 2)) AS BarDiscountPercent,
        barAmt,
        ROUND((TRY_CAST(bardis AS DECIMAL(10, 2)) / 100.0) * ISNULL(barAmt, 0), 2) AS BarDiscount,

        -- Bakery
        TRY_CAST(bakerydis AS DECIMAL(10, 2)) AS BakeryDiscountPercent,
        bakeryAmt,
        ROUND((TRY_CAST(bakerydis AS DECIMAL(10, 2)) / 100.0) * ISNULL(bakeryAmt, 0), 2) AS BakeryDiscount,

        -- Pizza
        TRY_CAST(pizzadis AS DECIMAL(10, 2)) AS PizzaDiscountPercent,
        pizzaAmt,
        ROUND((TRY_CAST(pizzadis AS DECIMAL(10, 2)) / 100.0) * ISNULL(pizzaAmt, 0), 2) AS PizzaDiscount,

        -- Room
        TRY_CAST(roomdis AS DECIMAL(10, 2)) AS RoomDiscountPercent,
        roomAmt,
        ROUND((TRY_CAST(roomdis AS DECIMAL(10, 2)) / 100.0) * ISNULL(roomAmt, 0), 2) AS RoomDiscount,

        -- Loyalty
        TRY_CAST(loyaltydis AS DECIMAL(10, 2)) AS LoyaltyDiscountPercent,
        ROUND((TRY_CAST(loyaltydis AS DECIMAL(10, 2)) / 100.0) * ISNULL(kotAmt, 0), 2) AS LoyaltyDiscount,

        -- Trading
        tradingAmt,
        tradingDis,
        ROUND((tradingDis / 100.0) * ISNULL(tradingAmt, 0), 2) AS TradingDiscount

    FROM ro_flatandPerDiscount
    WHERE SalesMasterId = @SalesMasterId
);

GO
