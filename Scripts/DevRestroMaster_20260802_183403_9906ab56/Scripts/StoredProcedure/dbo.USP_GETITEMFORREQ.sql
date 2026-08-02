SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_GETITEMFORREQ]
AS
BEGIN
select ITName as ItemName, IM.ITId as ItemID from dbo.ROI_ITEMMain im
	 WHERE PITId !=0 and im.IsArchived=0 and IsCategory=0 and IsActive=1 and IsMenu=0
	ORDER BY ITName 
END

GO
