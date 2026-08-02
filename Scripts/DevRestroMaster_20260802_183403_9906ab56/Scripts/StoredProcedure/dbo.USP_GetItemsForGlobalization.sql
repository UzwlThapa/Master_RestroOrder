SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--DROP  PROCEDURE USP_GetItemsForGlobalization 
CREATE PROCEDURE [dbo].[USP_GetItemsForGlobalization]
    @LanguageID INT AS;WITH CTE ( [Level], ITId, [path], ITName, PITId, IsActive, IsMenu, IsCategory, AddedBy, AddedOn ,
                                  UpdatedOn , UpdatedBy, IsUpdated, IsArchived, ArchivedBy, ArchivedOn, ParentItem ,
                                  ItemOrder , x )
                       AS ( SELECT 0 AS [Level] ,
                                   ITId ,
                                   CAST (ROW_NUMBER () OVER ( PARTITION BY PITId
                                                              ORDER BY ITName ) AS VARCHAR (MAX)) AS [path] ,
                                   ITName ,
                                   PITId ,
                                   IsActive ,
                                   IsMenu ,
                                   IsCategory ,
                                   AddedBy ,
                                   AddedOn ,
                                   UpdatedOn ,
                                   UpdatedBy ,
                                   IsUpdated ,
                                   IsArchived ,
                                   ArchivedBy ,
                                   ArchivedOn ,
                                   CAST ('' AS VARCHAR (250)) ParentItem ,
                                   CAST (ITId AS VARCHAR (50)) AS ItemOrder ,
                                   ROW_NUMBER () OVER ( PARTITION BY PITId
                                                        ORDER BY ITName ) / POWER (10.0, 0) AS x
                            FROM   ROI_ITEMMain
                            WHERE  ( PITId = 0
                                  OR PITId IS NULL )
                            AND    IsArchived = 0
                            AND    IsMenu = 1
                            UNION ALL
                            SELECT ( CTE.[Level] + 1 ) AS [Level] ,
                                   im.ITId ,
                                   CTE.[path] + '-' + CAST (ROW_NUMBER () OVER ( PARTITION BY im.PITId
                                                                                 ORDER BY im.ITName ) AS VARCHAR (MAX)) ,
                                   im.ITName ,
                                   im.PITId ,
                                   im.IsActive ,
                                   im.IsMenu ,
                                   im.IsCategory ,
                                   im.AddedBy ,
                                   im.AddedOn ,
                                   im.UpdatedOn ,
                                   im.UpdatedBy ,
                                   im.IsUpdated ,
                                   im.IsArchived ,
                                   im.ArchivedBy ,
                                   im.ArchivedOn ,
                                   CTE.ITName AS ParentItem ,
                                   CAST (CTE.ItemOrder + '.' + CAST (im.ITId AS VARCHAR (10)) AS VARCHAR (50)) AS ItemOrder ,
                                   x + ROW_NUMBER () OVER ( PARTITION BY im.PITId
                                                            ORDER BY im.ITName ) / POWER (10.0, Level + 1)
                            FROM   ROI_ITEMMain AS im
                                   INNER JOIN CTE ON im.PITId = CTE.ITId
                            WHERE  im.IsArchived = 0
                            AND    im.IsMenu = 1 )
    SELECT   ItemOrder ,
             ITId ,
             dbo.fn_LevelPrefix (CONVERT (INT, ISNULL ([Level], 0)), '----') + ITName AS ITName ,
             [path] ,
             PITId ,
             IsActive ,
             IsMenu ,
             IsCategory ,
             AddedBy ,
             AddedOn ,
             UpdatedOn ,
             UpdatedBy ,
             IsUpdated ,
             IsArchived ,
             ArchivedBy ,
             ArchivedOn ,
             ParentItem ,
             COALESCE (gm.[Text], ITName)
             AS
             LanguageMenuText
    FROM     CTE
             LEFT JOIN RO_GlobalizedMenu gm ON  CTE.ITId = gm.ItemID
                                            AND gm.LanguageID = @LanguageID
    ORDER BY x;


GO
