SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_ROI_getadjustmentType]

AS
select * from Ro_AdjustmentType where ISNULL(IsDeleted,0)=0



GO
