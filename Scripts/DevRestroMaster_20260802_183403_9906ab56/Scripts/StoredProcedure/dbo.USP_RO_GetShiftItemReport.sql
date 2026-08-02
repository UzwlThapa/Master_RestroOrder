SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_RO_GetShiftItemReport] 
@ItemName varchar(100)='', @FromTable varchar(100)='', @ToTable varchar(100)=''
, @ShiftedBy varchar(100)='', @FromDate Date=NULL, @ToDate Date=NULL
AS
SELECT i.ITName
      ,ft.restrotableTitle [FromTable]
      ,[FromSplitNo]
      ,isnull(tt.restrotableTitle,'Complementary') [ToTable]
      ,[ToSplitNo]
      ,[ShiftedBy]
      ,[Quantity]
      ,[IsCombo]
      ,[ShiftedOn]
  FROM [dbo].[RO_ItemShiftLog] isl
  LEFT JOIN ro_restroTable ft on isl.FromTable=ft.restrotableId
  LEFT JOIN ro_restroTable tt on isl.ToTable=tt.restrotableId
  LEFT JOIN roi_itemMain i on isl.ItemId=i.ITId
  WHERE 1=1
  AND (@ItemName=i.ITName or @ItemName='')
  AND (@FromTable=ft.restrotableTitle or @FromTable='' or @FromTable IS NULL)
  AND (@ToTable=tt.restrotableTitle or @ToTable='' or @ToTable IS NULL)
  AND (@ShiftedBy=[ShiftedBy] or @ShiftedBy=''or @ShiftedBy IS NULL)
  AND (CAST(DATEADD(hour,-4,ShiftedOn) as Date)>=@FromDate OR @FromDate IS NULL)
  AND (CAST(DATEADD(hour,-4,ShiftedOn) as Date)<=@ToDate OR @ToDate IS NULL)
  order by [ShiftedOn], i.ITName

GO
