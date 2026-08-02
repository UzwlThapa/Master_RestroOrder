SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_GetListsByPortalID]
 
 @PortalID INT,
 @Culture NVARCHAR(256)

AS
 SELECT DISTINCT 
  
  ListName,
  [Level],
  DefinitionID,
  PortalID,
  SystemList,
  EntryCount,
  ParentID,
  ParentKey,
  Parent,
  ParentList,
  MaxSortOrder
 FROM dbo.vw_Lists
 WHERE PortalID = @PortalID
 ORDER BY [Level], ListName
/****** Object:  StoredProcedure [dbo].[sp_GetMessageTemplate]    Script Date: 12/02/2012 12:28:41 ******/
SET ANSI_NULLS ON





GO
