SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_GetGarbageReport]
 @startDate datetime,
@endDate datetime ,
@ITId INT
as
SELECT        gd.GarbageId, gd.ITId, gd.Quantity
			, gd.OrderDetailsID, gd.TableId
			, gd.Addedby, gd.AddedOn, gd.Remarks
			, im.ITName , rt.restrotableTitle
FROM            RO_GarbageDetail AS gd INNER JOIN
                         ROI_ITEMMain AS im ON im.ITId = gd.ITId INNER JOIN
                         RO_restroTable AS rt ON rt.restrotableId = gd.TableId
						 where cast(gd.AddedOn as date) >= @startDate
						 and cast(gd.AddedOn as date) <= @endDate
						 and (gd.ITId = @ITId or @ITId=0)
						 AND isnull(IsCombo,0) = 0

						 UNION

SELECT        gd.GarbageId, gd.ITId, gd.Quantity
			, gd.OrderDetailsID, gd.TableId
			, gd.Addedby, gd.AddedOn, gd.Remarks
			, cm.Name as ITName, rt.restrotableTitle
FROM            RO_GarbageDetail AS gd INNER JOIN
                        RO_Combo cm ON cm.ComboID = gd.ITId INNER JOIN
                         RO_restroTable AS rt ON rt.restrotableId = gd.TableId
						 where cast(gd.AddedOn as date) >= @startDate
						 and cast(gd.AddedOn as date) <= @endDate
						 and (gd.ITId = @ITId or @ITId=0)
						 AND IsCombo = 1


GO
