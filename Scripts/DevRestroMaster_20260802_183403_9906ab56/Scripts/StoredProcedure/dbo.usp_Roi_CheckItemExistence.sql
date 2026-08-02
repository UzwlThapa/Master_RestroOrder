SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_Roi_CheckItemExistence]
    @item NVARCHAR (256)
AS
    SELECT ITId ,
           ITName
    FROM   dbo.ROI_ITEMMain
    WHERE  ITName = @item
    AND    IsCategory = 0
    AND    IsArchived = 0;

GO
