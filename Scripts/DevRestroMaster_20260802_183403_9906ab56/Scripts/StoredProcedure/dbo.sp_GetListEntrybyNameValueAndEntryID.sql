SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_GetListEntrybyNameValueAndEntryID]

 @ListName NVARCHAR(50),
 @Value NVARCHAR(200),
 @EntryID INT,
 @Culture NVARCHAR(256)

AS
 SELECT *
 FROM dbo.vw_Lists
 WHERE ([ListName] = @ListName OR @ListName='')
  AND ([EntryID]=@EntryID OR @EntryID = -1)
  AND ([Value]=@Value OR @Value = '') AND Culture=@Culture
  
/****** Object:  StoredProcedure [dbo].[sp_GetListEntrybyParentId]    Script Date: 12/02/2012 12:25:24 ******/
SET ANSI_NULLS ON





GO
