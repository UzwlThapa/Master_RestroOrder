SET QUOTED_IDENTIFIER ON;
SET ANSI_NULLS ON;
GO

/*
====================================
	Author: Unknown
    Creadted Date: Unknown
	Last Modified By: Yawahang
	Last Modified Date: 11/10/2023
====================================

EXEC dbo.USP_ROI_GETALLSTOCKREPORT @storeId = 0 ,    
                          @SearchText = N'' 

*/
ALTER PROCEDURE [dbo].USP_ROI_GETALLSTOCKREPORT
    @storeId INT ,
    @SearchText NVARCHAR (100)
AS
    BEGIN

        IF ( @storeId = 0 )
            BEGIN
                SELECT SRV.StockTranMasterId
                INTO   #Temp1
                FROM   [dbo].[vw_ROI_StockReportView] SRV
                       INNER JOIN ( SELECT   MAX (TransactionDate) AS TransactionDate ,
                                             ITId
                                    FROM     [dbo].[vw_ROI_StockReportView]
                                    GROUP BY ITId ,
                                             StoreId ) SV ON  SRV.ITId = SV.ITId
                                                          AND SRV.TransactionDate = SV.TransactionDate;


                WITH CTE
                AS ( SELECT   vrsrv.ITId ,
                              vrsrv.ITCode AS ITName ,
                              SUM ([vrsrv].ItemBalance) AS CLBal ,
                              vrsrv.Symbol ,
                              SUM (vrsrv.ItemValue) AS TotalValue
                     FROM     [dbo].[vw_ROI_StockReportView] AS [vrsrv]
                     WHERE    EXISTS ( SELECT 1
                                       FROM   #Temp1 t
                                       WHERE  t.StockTranMasterId = vrsrv.StockTranMasterId )
                     AND      ITCode LIKE '%' + @SearchText + '%'
                     GROUP BY ITId ,
                              ITCode ,
                              Symbol ,
                              ItemValue )
                SELECT   ITId ,
                         ITName ,
                         SUM (CLBal) AS CLBal ,
                         Symbol ,
                         SUM (TotalValue) AS TotalValue
                FROM     CTE
                GROUP BY ITId ,
                         ITName ,
                         Symbol
                ORDER BY ITName;

                DROP TABLE #Temp1;
            END;
        ELSE
            BEGIN
                SELECT SRV.StockTranMasterId ,
                       SRV.ITId ,
                       SRV.TransactionDate
                INTO   #Temp2
                FROM   [dbo].[vw_ROI_StockReportView] SRV
                       INNER JOIN ( SELECT   MAX (TransactionDate) AS TransactionDate ,
                                             ITId
                                    FROM     [dbo].[vw_ROI_StockReportView]
                                    GROUP BY ITId ,
                                             StoreId ) SV ON  SRV.ITId = SV.ITId
                                                          AND SRV.TransactionDate = SV.TransactionDate;

                SELECT   vrsrv.ITId ,
                         vrsrv.ITCode AS ITName ,
                         vrsrv.ItemBalance AS CLBal ,
                         vrsrv.Symbol ,
                         vrsrv.ItemValue AS TotalValue
                FROM     [dbo].[vw_ROI_StockReportView] AS vrsrv
                WHERE    EXISTS ( SELECT 1
                                  FROM   #Temp2 t
                                  WHERE  t.StockTranMasterId = vrsrv.StockTranMasterId )
                AND      ( ITCode LIKE '%' + @SearchText + '%' )
                AND      StoreId = @storeId
                ORDER BY ITName;

                DROP TABLE #Temp2;
            END;
    END;
GO

