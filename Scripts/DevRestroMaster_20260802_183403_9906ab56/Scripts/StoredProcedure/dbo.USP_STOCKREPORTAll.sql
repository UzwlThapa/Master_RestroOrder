SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--[dbo].[USP_STOCKREPORTAll] 0,''

CREATE PROCEDURE [dbo].[USP_STOCKREPORTAll]
    @storeId INT ,
    @SearchText NVARCHAR (100)
AS
    IF ( @storeId = 0 )
        BEGIN
            BEGIN
                --declare @storeId int=1
                SELECT   ITName ,
                         SUM (OPBal) OPBal ,
                         SUM (CLBal) CLBal ,
                         'kitchen' AS StName ,
                         ru.Symbol AS ITUnit ,
                         --,avg(ISNULL(CLRate,0)) as CLRate
                         CASE WHEN SUM (ISNULL (CLBal, 0)) = 0 THEN 0
                              ELSE ( SUM (ISNULL (CLBal, 0) * ISNULL (CLRate, 0)) / SUM (ISNULL (CLBal, 0)))
                         END AS CLRate ,
                         --,sum(ISNULL(CLBal,0)) * avg(ISNULL(CLRate,0)) as TotalValue
                         SUM (ISNULL (CLBal, 0) * ISNULL (CLRate, 0)) AS TotalValue
                INTO     #temp
                FROM     dbo.ROI_ITEMBal ib
                         INNER JOIN dbo.ROI_ITEMMain IM ON ib.ITId = IM.ITId
                         INNER JOIN dbo.ROI_Store RS ON RS.STId = ib.STId
                         LEFT JOIN ROI_ItemDetails itd ON IM.ITId = itd.ITId
                         LEFT JOIN ROI_Unit1 ru ON ru.Unit1Id = itd.SmallUnit
                WHERE    RS.IsDeleted = 0
                AND      IM.IsArchived = 0
                AND      IM.ITName LIKE '%' + @SearchText + '%'
                GROUP BY ITName ,
                         Symbol
                ORDER BY ITName;


                SELECT 0 ITId ,
                       ITName ,
                       OPBal ,
                       CLBal ,
                       ITUnit ,
                       0 STId ,
                       0 Unit1Id ,
                       '' UnitDescription ,
                       CASE WHEN CLRate < 0 THEN 0
                            ELSE CLRate
                       END CLRate ,
                       CASE WHEN TotalValue < 0 THEN 0
                            ELSE TotalValue
                       END TotalValue
                FROM   #temp;

            --where rs.STId=@storeId
            END;
        END;
    ELSE
        BEGIN
            BEGIN
                --declare @storeId int=1
                SELECT   IM.ITId ,
                         ITName ,
                         SUM (OPBal) OPBal ,
                         SUM (CLBal) CLBal ,
                         --,StName
                         ru.Symbol AS ITUnit ,
                         RS.STId ,
                         ru.Unit1Id ,
                         ru.UnitDescription ,
                         AVG (ISNULL (CLRate, 0)) AS CLRate ,
                         SUM (ISNULL (CLBal, 0)) * AVG (ISNULL (CLRate, 0)) AS TotalValue
                INTO     #temp2
                FROM     dbo.ROI_ITEMBal ib
                         INNER JOIN dbo.ROI_ITEMMain IM ON ib.ITId = IM.ITId
                         INNER JOIN dbo.ROI_Store RS ON RS.STId = ib.STId
                         LEFT JOIN ROI_ItemDetails itd ON IM.ITId = itd.ITId
                         LEFT JOIN ROI_Unit1 ru ON ru.Unit1Id = itd.SmallUnit
                WHERE    RS.STId = @storeId
                AND      RS.IsDeleted = 0
                AND      IM.IsArchived = 0
                AND      IM.ITName LIKE '%' + @SearchText + '%'
                --or PSTId=@storeId
                GROUP BY IM.ITId ,
                         ITName ,
                         RS.STId ,
                         ru.Unit1Id ,
                         ru.UnitDescription ,
                         --,StName
                         ru.Symbol
                ORDER BY ITName;

                SELECT ITId ,
                       ITName ,
                       OPBal ,
                       CLBal ,
                       ITUnit ,
                       STId ,
                       Unit1Id ,
                       UnitDescription ,
                       CASE WHEN CLRate < 0 THEN 0
                            ELSE CLRate
                       END CLRate ,
                       CASE WHEN TotalValue < 0 THEN 0
                            ELSE TotalValue
                       END TotalValue
                FROM   #temp2;
            END;

        END;

GO
